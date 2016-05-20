class EnrollmentsController  < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.enrollments.create(game: current_game)
    redirect_to game_path(current_game)
  end

  private

  def current_game
    @current_game ||= Game.find(params[:game_id])
  end
end
