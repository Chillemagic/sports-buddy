class AddNameToGameTeams < ActiveRecord::Migration[8.1]
  def change
    add_column :game_teams, :name, :string
  end
end
