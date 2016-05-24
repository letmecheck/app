module GameHelper
  def display_pieces(chess_pieces, x, y)
    piece = @game.pieces.where(x_coord: x, y_coord: y).first
    if piece.present?
      image_tag(piece.img, class: "img-responsive")
    end
  end
end
