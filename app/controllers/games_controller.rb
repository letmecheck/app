class GamesController < ApplicationController
  before_action :authenticate_user!

  def index
    @games = Game.all
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params)
    @game.white_player_id = current_user.id
    @game.save
    redirect_to game_path(@game)
  end

  def show
    @game = Game.find(params[:id])
  end

  def update
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end

  # def game_params
  #   params.require(:game).permit(:name, :white_player_id, :black_player_id)
  # end
end
