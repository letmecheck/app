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
    set_game_and_players_variables

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
    set_game_and_players_variables

    if current_user.id == @white_player.id

      @game.update_attribute(:white_player_concede, true)
      #@conceding_player = @white_player

    elsif current_user.id == @black_player.id

      @game.update_attribute(:black_player_concede, true)
      #@conceding_player = @black_player
    end

    conceding_player = params[:conceding_one] 

    redirect_to_concede_page(conceding_player)
  end

  def draw
    set_game_and_players_variables

    if current_user.id == @white_player.id

      @game.update_attribute(:white_player_draw, true)
      @draw_requesting_player_id = @white_player.id

    elsif current_user.id == @black_player.id

      @game.update_attribute(:black_player_draw, true)
      @draw_requesting_player_id = @black_player.id

    end

    if  one_player_has_requested_draw
      notify_other_player
    else
      redirect_to_draw_page #in this case, both players have agreed on a draw
    end

  end

  private

  def set_game_and_players_variables
    @game = Game.find_by_id(params[:id])
    @white_player = User.find_by_id(@game.white_player_id) unless @game.white_player_id.nil?
    @black_player = User.find_by_id(@game.black_player_id) unless @game.black_player_id.nil?
  end

  def redirect_to_draw_page
    Pusher["game-#{@game.id}"].trigger("game_drawn", bogus_data: 0)
  end

  def notify_other_player
    Pusher["game-#{@game.id}"].trigger("draw_requested", bogus_data: 0)
  end

  def redirect_to_concede_page(conceding_player)
    Pusher["game-#{@game.id}"].trigger("game_conceded", my_data: conceding_player)
  end

  def game_spot_open?
    @game.black_player_id.nil? && @game.white_player_id != current_user.id
  end

  def game_params
    params.require(:game).permit(:name)
  end

  def one_player_has_requested_draw
    return true if ( !@game.white_player_draw && @game.black_player_draw) || ( @game.white_player_draw && !@game.black_player_draw)
  end
end
