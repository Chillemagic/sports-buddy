class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game, only: %i[ show, edit, update, destroy ]

  def index
    @games = Game.all.order(created_at: :desc)
  end

  def new
    @game_teams = teams([ nil ])
    # Check if @game_teams.present? In view to decide whether the add a team select to menu
  end

  def create
    # Create via form on Create#new
    @game = Game.create!(game_params)
    # Set @game_team to form selection

    # Hanlde array of game teams from form:
    @selected_teams_ids = team_ids
    # Updates game_teams of at least one
    @selected_teams_ids.each { |team| add_game(team, @game) } if @selected_teams_ids.present?

    redirect_to @game, notice: "Game added"

  rescue ActiveRecord::RecordInvalid
    flash[:alert] = "Something went wrong"
    render :new
  end


  def show
    # Use to show the game_teams on the show page
    @teams = @game.game_teams
  end

  def edit
    # Edit form
    @game_teams = teams([ nil, @game.id ])
    # Populate in view if @game_team.where(game_id: @game.id).present?
  end

  def update
    @game.update!(game_params)
    # Teams that have been selected in the form.
    @selected_teams_ids = team_ids
    # Teams that have the @game.id
    @teams = teams([ @game.id ])
    @existing_team_ids = @teams.map(&:id).map(&:to_s)

    @teams.each do |team |
      unless @selected_teams_ids.include?(team.id.to_s)
        team.update!(game_id: nil)
      end
    end

    @selected_teams_ids.each do |team|
      unless @existing_team_ids.include?(team)
        add_game(team, @game)
      end
    end

    redirect_to @game, notice: "Game updated"

  rescue ActiveRecord::RecordInvalid
    flash[:alert] = "Something went wrong"
    render :edit
  end

  private

  def teams(array)
    GameTeam.where(game_id: array)
  end

  def team_ids
    params[:game][:game_team_ids]
  end

  def add_game(team, game)
    @team = GameTeam.find(team)
    @team.update!(game_id: game.id)
  end

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:date, :location, :game_team_ids, :name)
  end
end
