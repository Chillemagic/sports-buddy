class GameTeam < ApplicationRecord
  has_many :game_team_users
  has_many :users, through: :game_team_users
  has_many :chats, dependent: :destroy
  belongs_to :game, optional: true
end
