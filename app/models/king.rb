class King < Piece
  def valid_move?(new_x, new_y)
    return false if off_board?(new_x, new_y)
    return false if current_square?(new_x, new_y)

    x_offset, y_offset = movement_by_axis(new_x, new_y)
    return true if (-1..1).cover?(x_offset) && (-1..1).cover?(y_offset)

    in_check?(new_x, new_y)

    valid_castling?(new_x, new_y)
  end

  # Determine if the king is being moved into a position resulting in check
  def in_check?(new_x, new_y)
    opponent_color = (color == 'white') ? 'black' : 'white'
    live_pieces = game.pieces.where(color: opponent_color)
    live_pieces.each do |piece|
      return false if piece.valid_move?
    end
  end

  # Determine if castling is allowed.
  def valid_castling?(new_x, new_y)
    # The right to castle has been lost if the king has moved.
    return false if moved?

    # Castling is permitted if the king and the chosen rook are on the player's first rank.
    return false unless nth_rank(1) == new_y

    # Castling is not permitted unless the king moves two spaces along the same rank.
    return false unless new_x == 3 || new_x == 7

    # Castling is not permitted if the rook has moved, or if there are any obstructions.
    rook_file(new_x, new_y)
  end

  # Ensures that Castling is only permitted on the first rank relative to the player.
  def nth_rank(n)
    color == 'white' ? n : 9 - n
  end

  # Castling helper method.
  def rook_file(new_x, new_y)
    # Set the file for the rook to 1 if the player's intent is to Castle to their left,
    # otherwise it will be set to eight.
    rook_file = new_x == 3 ? 1 : 8
    rook = game.piece_at(rook_file, new_y)

    # The right to castle has been lost if the rook has moved earlier in the game.
    return false if rook.moved?

    # Castling is prevented temporarily if there is any piece between the king and the rook.
    return false if obstructed?(rook_file, new_y)
    true
  end

  # Castling is prevented temporarily:
  # if the square on which the king stands, or the square which it must cross,
  # or the square which it is to occupy, is attacked by one or more of the
  # opponent's pieces.
  # def threatened_squares
  # make sure that the following squares are not being attacked
  #   (3..5) || (5..7)
  # end
end
