class CreateGameTeams < ActiveRecord::Migration[8.1]
  def change
    create_table :game_teams do |t|
      t.timestamps
    end
  end
end
