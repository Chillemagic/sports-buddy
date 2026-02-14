class AddForeignKeyToGameTeams < ActiveRecord::Migration[8.1]
  def change
    add_reference :game_team_users, :game_team, foreign_key: true
  end
end
