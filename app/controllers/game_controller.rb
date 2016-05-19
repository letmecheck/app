class GameController < ApplicationController
	def index
<<<<<<< HEAD

=======
>>>>>>> master
	end

	def new
		@game = Game.new
	end

	def show
		@game = Game.find_by_id(params[:id])
	end

	def create
		@game = Game.create(game_params)
	end

	def update

	end

	private

	def game_params
		params.require(:game).permit(:name)
	end

end
