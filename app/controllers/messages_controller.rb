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
