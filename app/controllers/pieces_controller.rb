class PiecesController < ApplicationController
  def show
    @piece = Piece.find(params[:id])
  end

  def update
    @piece = Piece.find(params[:id])
    if @piece.move_to!(piece_params[:x_coord].to_i, piece_params[:y_coord].to_i)
      # Trigger update notification.
      Pusher["game-#{@piece.game.id}"].trigger('move_made', {})
    end
  end

  private

  def piece_params
    params.require(:piece).permit(:x_coord, :y_coord)
  end
end
