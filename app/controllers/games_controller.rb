class GamesController < ApplicationController

	def index
		@games = Game.all
	end

	def new
		@game = Game.new
	end

	def create
		@game = current_user.games.create(game_params)
		@game.white_player_id = @game.user_id
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

end
