class EnrollmentsController  < ApplicationController
  before_action :authenticate_user!
  helper_method :current_game

  def create
    current_user.enrollments.create(game: current_game)
    current_game.black_player_id = current_game.black_player.id #this is my current way of making sure that only one person can join a game.
                                                                #this is because of the has_one method in the enrollment model. 
    current_game.save
    redirect_to game_path(current_game)
  end

  private

  def current_game
    @current_game ||= Game.find(params[:game_id])
  end
end
