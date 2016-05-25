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
  	@white_player = User.find(@game.white_player_id) unless @game.white_player_id.nil?
  	@black_player = User.find(@game.black_player_id) unless @game.black_player_id.nil?
  	@chess_pieces = @game.pieces
  end

	def update
		@game = Game.find(params[:id])
		if @game.black_player_id.nil? && @game.white_player_id != current_user.id
			@game.black_player_id = current_user.id
			@game.save
			redirect_to game_path(@game)
		else
			render text: 'The game is already full!', status: :unauthorized
		end
	end

  private

  def game_params
    params.require(:game).permit(:name)
  end

	#helper_method :current_game
	#def current_game
	#	@currentgame ||= Game.find(params[:id])
	#end

	# def game_params
	#	  params.require(:game).permit(:name, :white_player_id, :black_player_id)
	# end
end
