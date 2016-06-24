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

    conceding_player_id = params[:conceding_user]

    if conceding_player_id == @white_player.id.to_s

      @game.update_attribute(:game_conceding_player, "white")

    elsif conceding_player_id == @black_player.id.to_s

      @game.update_attribute(:game_conceding_player, "black")

    end

    load_concede_page(conceding_player_id)
  end

  def draw
    set_game_and_players_variables
    
    draw_requesting_player = params[:draw_requesting_user]

    if draw_requesting_player == @white_player.id.to_s

      @game.update_attribute(:white_player_draw, true)

    elsif draw_requesting_player == @black_player.id.to_s

      @game.update_attribute(:black_player_draw, true)

    end

    if  one_player_has_requested_draw
      change_button_message
    else #in this case, both players have agreed on a draw
      load_draw_page 
    end

  end

  def change_button_version #this controller action serves only to allow
  #the loading of the view file with the same name without errors
    set_game_and_players_variables
  end

  private

  def set_game_and_players_variables
    @game = Game.find_by_id(params[:id])
    @white_player = User.find_by_id(@game.white_player_id) unless @game.white_player_id.nil?
    @black_player = User.find_by_id(@game.black_player_id) unless @game.black_player_id.nil?
  end

  def change_button_message
    Pusher["game-#{@game.id}"].trigger("draw_requested", bogus_data: nil)
  end

  def load_draw_page
    Pusher["game-#{@game.id}"].trigger("game_drawn", bogus_data: nil)
  end

  def load_concede_page(conceding_player_id)
    Pusher["game-#{@game.id}"].trigger("game_conceded", player_id: conceding_player_id)
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
