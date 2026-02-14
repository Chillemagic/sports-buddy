class AddFieldsToChat < ActiveRecord::Migration[8.1]
  def change
        add_reference :chats, :game_team, foreign_key: true
  end
end
