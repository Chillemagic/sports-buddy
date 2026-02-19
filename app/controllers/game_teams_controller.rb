class GameTeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game_team, only: %i[ create edit destroy]

  def index
    @game_teams = GameTeam.all
  end

  def show
    @chat = @game_team.chats.first
  end

  def create
    GameTeam.create!(game_team_params)
      redirect_to @game_team, notice: "Game Team added"
  rescue ActiveRecord::RecordInvalid
    flash[:alert] = "Something went wrong"
    render :new
  end

  def edit
  end

  def destroy
    @game_team.destroy
  end

  private

  def set_game_team
    @game_team = GameTeam.find(params[:id])
  end

  def game_team_params
    params.require(:game_team).permit(:game_id, :name)
  end
end
