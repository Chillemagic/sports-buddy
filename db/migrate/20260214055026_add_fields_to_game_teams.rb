class AddFieldsToGameTeams < ActiveRecord::Migration[8.1]
  def change
    add_column :game_teams, :players, :string, array: true, default: []
    add_reference :game_teams, :game, foreign_key: true
  end
end
