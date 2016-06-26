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

  def add_squash_class(x, y)
    + " squash-me" if x == 9
    + " squash-me" if y == 0 || x == 9
  end

  def add_rank_indicator_class(x, y)
    + " rank-indicator center-text rank-and-file" if x == 0 && y != 0
  end

  def add_file_indicator_class(x, y)
    + " file-indicator center-text rank-and-file" if y == 0 && (x != 9 && x != 0)
  end

  def convert_number_to_file_letter(x, y)
    (x + 96).chr if y == 0 && x != 0 && x != 9
  end
end
