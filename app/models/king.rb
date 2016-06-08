class King < Piece
  def valid_move?(new_x, new_y)
    return false if off_board?(new_x, new_y)
    return false if current_square?(new_x, new_y)
    # return false if in_check?(new_x, new_y)

    x_offset, y_offset = movement_by_axis(new_x, new_y)
    return true if (-1..1).cover?(x_offset) && (-1..1).cover?(y_offset)

    valid_castling?(new_x, new_y)
  end

  private

  # Determine if castling is allowed.
  def valid_castling?(new_x, new_y)
    # The right to castle has been lost if the king has moved.
    return false if moved?

    # Castling is permitted if the king and the chosen rook are on the player's first rank.
    # Since the king hasn't moved, then y_coord will be the same as the player's first rank.
    return false unless y_coord == new_y

    # Castling is not permitted unless the king moves two spaces along the same rank.
    return false unless new_x == 3 || new_x == 7

    # Castling is not permitted if the rook has moved, or if there are any obstructions.
    return false unless rook_requirements(new_x, new_y)

    # Allows Castling if the squares that the king traverses are not under attack.
    !king_traversal_under_attack?(new_x, new_y)
  end

  # Castling helper method.
  def rook_requirements(new_x, new_y)
    # Set the file for the rook to 1 if the player's intent is to Castle queen-side,
    # otherwise it will be set to eight.
    rook_file = new_x == 3 ? 1 : 8

    # Guard against the rook's square being empty.
    return false if game.piece_at(rook_file, new_y) == nil

    # Assign a variable to the piece found in the rook's square. This handles either situation
    # whether the piece is a rook or not.
    rook = game.piece_at(rook_file, new_y)

    # The right to castle has been lost if the rook has moved earlier in the game.
    return false if rook.moved?

    # Castling is prevented temporarily if there is any piece between the king and the rook.
    return false if obstructed?(rook_file, new_y)
    true
  end

  # Helper method used to determine if a particular square is under potential attack
  def square_threatened?(destination_x, destination_y)
    opponent_color = (color == 'white') ? 'black' : 'white'
    enemy_pieces = game.pieces.where(color: opponent_color)
    enemy_pieces.each do |piece|
      return true if piece.valid_move?(destination_x, destination_y)
    end
    false
  end

  # Castling is prevented temporarily:
  # if the square on which the king stands, or the square which it must cross,
  # or the square which it is to occupy, is attacked by one or more of the opponent's pieces.
  def king_traversal_under_attack?(new_x, new_y)
    # The argument for new_x will be either 3 or 7 if castling is attempted.
    king_file_array = (new_x == 3) ? [3, 4, 5] : [5, 6, 7]

    # File is a chess term that's analogous to x_coord
    king_file_array.each do |file|
      return true if square_threatened?(file, new_y)
    end
    false
  end
end
