class CreateGames < ActiveRecord::Migration[8.1]
  def change
    create_table :games do |t|
      t.string :teams, array: true, default: []
      t.datetime :date
      t.timestamps
    end
  end
end
