class PiecesController < ApplicationController
  def show
    @piece = Piece.find(params[:id])
  end

  def update
    @piece = Piece.find(params[:id])
    @piece.move_to!(piece_params[:x_coord].to_i, piece_params[:y_coord].to_i)

    # instance variables employed by update.js.erb
    @black_king_in_check = @piece.game.in_check?('black')
    @white_king_in_check = @piece.game.in_check?('white')
  end

  private

  def piece_params
    params.require(:piece).permit(:x_coord, :y_coord)
  end
end
