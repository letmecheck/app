module GameHelper
  def display_pieces(x, y)
    piece = @game.pieces.where(x_coord: x, y_coord: y).first
    image_tag(piece.img, class: "img-responsive") if piece.present?
  end
end
