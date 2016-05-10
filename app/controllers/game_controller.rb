class GameController < ApplicationController

	def index
		
	end

	def new
		@game = Game.new
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
