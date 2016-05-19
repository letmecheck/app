class GamesController < ApplicationController
	#before_action :authenticate_user!
	def new
		@game = Game.new
	end

	def create
		@game = Game.new(	name: "test",
											white_player_id: 1,
											black_player_id: 1)
		@game.save 
		redirect_to game_path(@game)
	end

	def show
		@game = Game.find(params[:id])		
	end

	private

	#def game_params
	#	params.require(:game).permit(:name, :white_player_id, :black_player_id)
	#end
end
