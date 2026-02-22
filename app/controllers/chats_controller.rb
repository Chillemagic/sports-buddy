class ChatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat, only: [ :show ]
  before_action :set_game_team, only: %i[ index new create ]

  def index
    # Load game_team_id then only call chats for @game_team
    @chats = @game_team.chats.order(created_at: :desc)
  end

  def new
    @chat = @game_team.chats.build
    # @selected_model = params[:model]
  end

  def create
    return unless prompt.present? || attachments.present?

    # Determine model based on file type
    model_to_use = determine_model_from_attachments

    # Create the chat with determined model
    @chat = @game_team.chats.build(
      model: model_to_use,
      **chat_params
    )

    if @chat.save
      # Create the initial user message with attachments
      message = @chat.messages.build(content: prompt, role: "user")

      # Attach files if provided
      if attachments.present?
        attachments.each do |file|
          message.attachments.attach(file)
        end
      end

      message.save!

      # Enqueue job with message that has attachments
      ChatResponseJob.perform_later(@chat.id, prompt)
      redirect_to @chat, notice: "Chat was successfully created."
    else
      redirect_to new_game_team_chat_path(@game_team), alert: "Error creating chat"
    end
  end

  def show
    @message = @chat.messages.build
  end

  private

  def chat_params
    params.require(:chat).permit(:model, :game_team_id)
  end

  def determine_model_from_attachments
    # If no attachments, use explicitly provided model or default
    return Model.find_by(model_id: model) if attachments.blank? || model.present?

    # Determine model based on first attachment's file type
    first_attachment = attachments.first
    content_type = first_attachment.content_type

    model_id =  case content_type
                when /^application\/pdf$/
                  "gemini-3-flash-preview"
                when /^image\//
                  "gpt-4o"
                when /^audio\//
                  "gpt-4o-audio-preview"
                else
                  "gpt-4.1-mini-2025-04-14"  # Default fallback
                end

   provider = get_provider(model_id)

   Model.find_by(model_id: model_id, provider: provider )
  end

  def set_chat
    @chat = Chat.find(params[:id])
  end

  def model
    params[:chat][:model].presence
  end

  def set_game_team
    game_team_id = params[:game_team_id].presence || params.dig(:chat, :game_team_id)
    @game_team = GameTeam.find(game_team_id)
  end

  def prompt
    params[:chat][:prompt]&.presence
  end

  def attachments
    file = params[:chat][:file]&.presence || []
    file ? [file] : []
  end

  def get_provider(model_id)
    model_id == "gemini-3-flash-preview" ? "gemini" : "openai"
  end
end
