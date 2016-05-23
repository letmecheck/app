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
  	current_game
		@white_player = User.find(current_game.white_player_id)
		@black_player = User.find(current_game.black_player_id)  
		@chess_pieces = current_game.pieces.where(game_id: current_game.id).take # ActiveRecord query		
  end

	def update
		if current_game.black_player_id.nil? && current_game.white_player_id != current_user.id
			current_game.black_player_id = current_user.id 
			current_game.save
			redirect_to game_path(current_game)
		else
			render text: 'The game is already full!', status: :unauthorized	
		end
	end

  private

  def game_params
    params.require(:game).permit(:name)
  end

	helper_method :current_game	
	def current_game
		@current_game ||= Game.find(params[:id])	
	end

	# def game_params
	#	  params.require(:game).permit(:name, :white_player_id, :black_player_id)
	# end
end

