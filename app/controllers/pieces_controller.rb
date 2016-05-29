class PiecesController < ApplicationController

  def show
    @piece = Piece.find(params[:id])
  end

  def update
    @piece = Piece.find(params[:id])
    @piece.move_to!(piece_params[:x_coord], piece_params[:y_coord])
    redirect_to game_path(@piece.game)
  end

  private

  def piece_params
    params.require(:piece).permit(:x_coord, :y_coord)
  end
end
