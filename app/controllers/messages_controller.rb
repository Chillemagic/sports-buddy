class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat

  def create
    return unless message_content.present? || attachments.present?

    # Explicitly create and save the user message with attachments
    @message = Message.new(chat_id: @chat.id, content: message_content, role: "user")

    # Attach files if provided
    if attachments.present?
      attachments.each do |file|
        @message.attachments.attach(file)
      end
    end

    @message.save!

    # Now enqueue job with message that has attachments
    ChatResponseJob.perform_later(@chat.id, message_content)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @chat }
    end
  end

  private

  def set_chat
    @chat = Chat.find(params[:chat_id])
  end

  def message_content
    params[:message][:content]&.presence
  end

  def attachments
    params[:message][:attachments]&.presence || []
  end
end
