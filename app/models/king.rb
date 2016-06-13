class King < Piece
  def valid_move?(new_x, new_y)
    return false if off_board?(new_x, new_y)
    return false if current_square?(new_x, new_y)

    x_offset, y_offset = movement_by_axis(new_x, new_y)
    (-1..1).cover?(x_offset) && (-1..1).cover?(y_offset) || valid_castling?(new_x, new_y)
  end

  # An addition to the move_to! method found within the Piece model.
  # This determines which rook is to be castled and moves it to the
  # appropriate square.
  def move_to!(destination_x, destination_y)
    return false unless valid_move?(destination_x, destination_y)
    castling = (x_coord - destination_x).abs == 2

    # Call the move_to! method within the Piece model and move the king.
    super

    # If all of the requirements are met for valid_move? AND the intention is to castle;
    # place the rook in its appropriate position to complete the castling move.
    if castling
      rook_origin_file = (destination_x == 3) ? 1 : 8
      rook_destination_file = (destination_x == 3) ? 4 : 6
      castled_rook = game.piece_at(rook_origin_file, destination_y)
      castled_rook.update_attributes(x_coord: rook_destination_file,
                                     y_coord: destination_y,
                                     moved: true)
    end
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
    return false unless rook_requirements_met?(new_x, new_y)

    # Allows Castling if the squares that the king traverses are not under attack.
    !king_traversal_under_attack?(new_x, new_y)
  end

  # Castling helper method.
  def rook_requirements_met?(new_x, new_y)
    # Set the x_coord for the rook to 1 if the player's intent is to Castle queen-side,
    # otherwise it will be set to eight.
    rook_x_coord = new_x == 3 ? 1 : 8

    # Assign a variable to the piece found in the rook's square.
    rook = game.piece_at(rook_x_coord, new_y)

    # Guard against the rook's square being empty, or some other piece.
    return false unless rook.is_a? Rook

    # The right to castle has been lost if the rook has moved earlier in the game.
    return false if rook.moved?

    # Castling is prevented temporarily if there is any piece between the king and the rook.
    !obstructed?(rook_x_coord, new_y)
  end

  # Castling is prevented temporarily:
  # if the square on which the king stands, or the square which it must cross,
  # or the square which it is to occupy, is attacked by one or more of the opponent's pieces.
  def king_traversal_under_attack?(new_x, new_y)
    # The argument for new_x will be either 3 or 7 if castling is attempted.
    king_x_array = (new_x == 3) ? [3, 4, 5] : [5, 6, 7]

    # square_threatened_by? takes color as one of its arguments.
    opponent_color = (color == 'white') ? 'black' : 'white'

    # Determine if any squares from the king's origin to his destination are under threat.
    king_x_array.any? { |x_coord| game.square_threatened_by?(opponent_color, x_coord, new_y) }
  end
end
