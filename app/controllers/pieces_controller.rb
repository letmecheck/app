class PiecesController < ApplicationController
  def show
    @piece = Piece.find(params[:id])
  end

  def update
    @piece = Piece.find(params[:id])
    @piece.move_to!(piece_params[:x_coord].to_i, piece_params[:y_coord].to_i)
    # The following three lines are for testing purposes and are to be removed after review.
    # black_check = @piece.game.in_check?('black')
    # white_check = @piece.game.in_check?('white')
    # flash.notice = "in check? White: #{white_check} Black: #{black_check}"
  end

  private

  def piece_params
    params.require(:piece).permit(:x_coord, :y_coord)
  end
end
