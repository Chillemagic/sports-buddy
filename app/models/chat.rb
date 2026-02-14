class Chat < ApplicationRecord
  acts_as_chat messages_foreign_key: :chat_id
  belongs_to :game_team
end
