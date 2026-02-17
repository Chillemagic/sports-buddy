class Game < ApplicationRecord
  # Association
  has_many :game_teams
  # Form Helper
  accepts_nested_attributes_for :game_teams
end
