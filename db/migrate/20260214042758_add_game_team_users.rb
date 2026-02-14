class AddGameTeamUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :game_team_users do |t|
      t.timestamps null: false
      ## Rememberable
      t.datetime :remember_created_at
      t.references :user, null: false, foreign_key: true
    end
  end
end
