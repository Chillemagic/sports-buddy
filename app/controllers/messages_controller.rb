class MessagesController < ApplicationController
  before_action :set_chat
  before_action :authenticate_user!

  def create
    return unless content.present?

    @message = @chat.messages.build(content: content, role: "user")
    @message.save

    ChatResponseJob.perform_later(@chat.id, content)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @chat }
    end
  end

  private

  def set_chat
    @chat = Chat.find(params[:chat_id])
  end

  def content
    params[:message][:content]
  end
end

def create_2
  @chat = current_user.chats.find(params[:chat_id]) # Handled by set_chat don't need this
  @game_team = @chat.game_team  # Not sure why I'd need this?
  @message = Message.new(content)
  @message.chat = @chat
  @message.role = "user"

  if @message.save
    @ruby_llm_chat = RubyLLM.chat
    build_conversation_history
    response = @ruby_llm_chat.with_instructions(instructions).ask(@message.content)

    @chat.messages.create(role: "assistant", content: response.content)
    @chat.generate_title_from_first_message
  else
    render "chats/show", status: :unprocessable_entity
  end

  def build_conversation_history
    @chat.messages.each do |message|
      @ruby_llm_chat.add_message(message)
    end
  end
end
