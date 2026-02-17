# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "date"
dt = DateTime.new(2026, 3, 14, 10, 0, 0)



puts "Clearing DB 🧹"
puts "Clearing DB 🧹"
ToolCall.destroy_all          # references messages
Message.destroy_all           # references chats, models, tool_calls
Chat.destroy_all              # references game_teams, models
GameTeamUser.destroy_all      # references game_teams, users
GameTeam.destroy_all          # references games
Game.destroy_all
User.destroy_all
Model.destroy_all
puts "DB clean 🧼"

puts "creating game 🎮"
game = Game.create!(date: dt, location: "Henson Park")
puts "Game created game id:#{game.id}, date:#{game.date}, location:#{game.location}"
puts "Creating game team 🥎"
game_team = GameTeam.create!(game_id: game.id, name: "Funky Monks")
puts "Created game team name: #{game_team.name}, game_id:#{game_team.id}"
puts "Creating user 🧙‍♂️"
user = User.create!(email: "no@email.com", password: "secret1")
puts "Successfully created user 😉, User email:#{user.email}"
gtu = GameTeamUser.create!(user_id: user.id, game_team_id: game_team.id)
puts "Succesfully created Game Team User, id:#{gtu.id}, user id:#{gtu.user_id}, game_team_id:#{gtu.game_team_id}"
puts "Successfully seeded 🌱"
