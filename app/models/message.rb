class Message < ApplicationRecord
  acts_as_message tool_calls_foreign_key: :message_id
  has_many_attached :attachments

  MAX_USER_MESSAGES = 10

  validate :user_message_limit, if: -> { role == "user" }

  broadcasts_to ->(message) { "chat_#{message.chat_id}" }

  def broadcast_append_chunk(content)
    broadcast_append_to "chat_#{chat_id}",
      target: "message_#{id}_content",
      partial: "messages/content",
      locals: { content: content }
  end

  def user_message_limit
    if chat.messages.where(role: "user").count >= MAX_USER_MESSAGES
      errors.add(:content, "You can only send #{MAX_USER_MESSAGES} messages per chat.")
    end
  end
end
