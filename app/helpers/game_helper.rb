module GameHelper
  def game_pieces(game, x, y)
    piece = game.pieces.find_by(x_coord: x, y_coord: y)
    return display_game_pieces(game, x, y) if piece.present?
  end

  def display_game_pieces(game, x, y)
    piece = game.pieces.where(x_coord: x, y_coord: y).first
    image_tag(
      piece.img,
      class: "img-responsive chessPiece",
      data: { url: piece_url(piece) },
      id: add_king_id(piece)
    )
  end

  def add_king_id(piece)
    color = (piece.color == 'white') ? 'white' : 'black'
    return color + '-king' if piece.piece_type == 'King'
  end

  def add_squash_class(x)
    + " squash-me" if x == 9
  end

  def add_rank_indicator_class(x)
    + " rank-indicator center-text" if x == 0
  end
end
