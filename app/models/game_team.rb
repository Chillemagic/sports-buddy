class GameTeam < ApplicationRecord
  has_many :game_team_users
  has_many :users, through: :game_team_users
  has_many :chats
  belongs_to :game
end
