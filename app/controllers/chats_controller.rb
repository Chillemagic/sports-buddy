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
    @selected_model = params[:model]
  end

  def create
    # Handle game_team_id Here
    return unless prompt.present?

    # Results in duplicate messages
    @chat = @game_team.chats.create!(model: Model.find_by(model_id: model))
    ChatResponseJob.perform_later(@chat.id, prompt)

    redirect_to @chat, notice: "Chat was successfully created."
  end

  def show
    @message = @chat.messages.build
  end

  private

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
    params[:chat][:prompt]
  end
end
