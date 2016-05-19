class GamesController < ApplicationController
	#before_action :authenticate_user!

	def create
		@game = Game.create 
		redirect_to @game
	end

	def show
		@game = Game.find(params[:id])		
	end

	private

	#def game_params
	#	params.require(:game).permit(:name, :white_player_id, :black_player_id)
	#end
end
