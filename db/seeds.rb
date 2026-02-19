# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.create!(
  first_name: "Sports",
  last_name: "Buddy",
  email: "sports@test.com",
  password: "secret",
  password_confirmation: "secret"
)

User.create!(
  first_name: "Test",
  last_name: "Test",
  email: "test@test.com",
  password: "secret",
  password_confirmation: "secret"
)
