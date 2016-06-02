module PieceHelper
  def display_piece_pieces(x, y)
    if @piece == @piece.game.pieces.find_by(x_coord: x, y_coord: y)
      image_tag(@piece.img, class: "img-responsive active selected-piece") if @piece.present?
    else
      @other_piece = @piece.game.pieces.find_by(x_coord: x, y_coord: y)
      image_tag(@other_piece.img, class: "img-responsive non-selected-piece") if @other_piece.present?
    end
  end
end
