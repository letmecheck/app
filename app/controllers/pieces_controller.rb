class PiecesController < ApplicationController
	def update_piece
		@piece = Piece.find(params[:id])
		@game = @piece.game
	end

	private

	def piece_params
		@piece_params = params.require(:piece).permit(:x_coord, :y_coord, :piece_type)
	end
end
