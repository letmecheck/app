module GameHelper
  def display_pieces(game, x, y)
    if game.pieces.where(x_coord: x, y_coord: y).take.present?
      piece_image = game.pieces.where(x_coord: x, y_coord: y).take.img
      image_tag(piece_image, class: "img-responsive")
    end
  end
end
