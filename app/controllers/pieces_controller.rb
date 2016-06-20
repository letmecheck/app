class PiecesController < ApplicationController
  def show
    @piece = Piece.find(params[:id])
  end

  def update
    @piece = Piece.find(params[:id])
    original_x = @piece.x_coord
    original_y = @piece.y_coord
    if @piece.move_to!(piece_params[:x_coord].to_i, piece_params[:y_coord].to_i)
      trigger_notification(original_x, original_y)
    end
  end

  private

  def piece_params
    params.require(:piece).permit(:x_coord, :y_coord)
  end

  def trigger_notification(original_x, original_y)
    Pusher["game-#{@piece.game.id}"].trigger(
      'move_made',
      piece_url: piece_url(@piece),
      orig_x: original_x,
      orig_y: original_y,
      dest_x: piece_params[:x_coord].to_i,
      dest_y: piece_params[:y_coord].to_i
    )
  end
end
