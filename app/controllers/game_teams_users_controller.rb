class GameTeamsUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game_team_user, only: [ :destroy ]
  before_action :set_game_team


  def index
    @game_team_users = GameTeamUser.all
  end

  def create
    @game_team.game_team_users.create!(game_team_user_params)
    redirect_to @game_team, notice: "User added"

  rescue ActiveRecord::RecordInvalid
    flash[:alert] = "Something went wrong"
    render :new
  end

  def destroy
    @game_team_user.destroy!
  end

  private

  def set_game_team_user
    @game_team_user = GameTeamUser.find(params[:id])
  end

  def set_game_team
    @game_team = GameTeam.find(params[:game_team_id])
  end

  def game_team_user_params
    params.require(:game_team_user).permit(:user_id)
  end
end
