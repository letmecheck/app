class PiecesController < ApplicationController

  def create
    Piece.create(params[:x_coord, :y_coord])
  end

end
