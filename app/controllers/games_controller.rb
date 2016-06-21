class GamesController < ApplicationController
  before_action :authenticate_user!
  #after_concede :push_notification

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
    @game = Game.find_by_id(params[:id])
    @white_player = User.find_by_id(@game.white_player_id) unless @game.white_player_id.nil?
    @black_player = User.find_by_id(@game.black_player_id) unless @game.black_player_id.nil?
    @chess_pieces = @game.pieces

  end

  def update
    @game = Game.find_by_id(params[:id])
    if game_spot_open?
      @game.update_attribute(:black_player_id, current_user.id)
      redirect_to game_path(@game)
    else
      render text: 'The game is already full!', status: :unauthorized
    end
  end

  def concede
    @game = Game.find_by_id(params[:id])

    @white_player = User.find_by_id(@game.white_player_id) unless @game.white_player_id.nil?
    @black_player = User.find_by_id(@game.black_player_id) unless @game.black_player_id.nil?

    if current_user.id == @white_player.id

      @game.update_attribute(:white_player_concede, true)
      @conceding_player = @white_player.email

    elsif current_user.id == @black_player.id

      @game.update_attribute(:black_player_concede, true)
      @conceding_player = @black_player.email
    end

    reload_other_player_page

    render "show"
  end

  def draw
    @game = Game.find_by_id(params[:id])

    @white_player = User.find_by_id(@game.white_player_id) unless @game.white_player_id.nil?
    @black_player = User.find_by_id(@game.black_player_id) unless @game.black_player_id.nil?

    if current_user.id == @white_player.id

      @game.update_attribute(:white_player_draw, true)
      @draw_requesting_player_id = @white_player.id

    elsif current_user.id == @black_player.id

      @game.update_attribute(:black_player_draw, true)
      @draw_requesting_player_id = @black_player.id

    end

    change_button_message

    render nothing: true

  end

  private

  def change_button_message
    Pusher["game-#{@game.id}"].trigger("draw_requested", 
      {requesting_player_id: @draw_requesting_player_id,
       current_user_id: current_user.id})
  end

  def reload_other_player_page
    Pusher["game-#{@game.id}"].trigger("game_conceded", bogus_data: 0)
  end

  def game_spot_open?
    @game.black_player_id.nil? && @game.white_player_id != current_user.id
  end

  def game_params
    params.require(:game).permit(:name)
  end
end
