class Pawn < Piece
  def valid_move?(new_x, new_y)
    return false if off_board?(new_x, new_y)

    offset = movement_by_axis(new_x, new_y)

    offset[1] *= -1 if color == 'black'

    return valid_standard_move?(new_x, new_y) if offset == [0, 1]

    return valid_double_move?(new_x, new_y) if offset == [0, 2]

    return valid_capture?(new_x, new_y) if [[-1, 1], [1, 1]].include? offset

    false
  end

  private

  def valid_standard_move?(new_x, new_y)
    !game.piece_at(new_x, new_y)
  end

  def valid_double_move?(new_x, new_y)
    return false unless y_coord == nth_rank(2)
    return false if game.piece_at(new_x, nth_rank(3))
    !game.piece_at(new_x, new_y)
  end

  def valid_capture?(new_x, new_y)
    # If there is a piece at the destination, the capture is valid if it's an
    # enemy piece, and invalid if friendly. Otherwise, determine whether an
    # en passant capture is possible.
    destination_piece = game.piece_at(new_x, new_y)
    return destination_piece.color != color if destination_piece

    # To make an en passant capture, the pawn must start on its fifth rank
    # (i.e., have a y_coord of 5 if white, or 4 if black)...
    return false unless y_coord == nth_rank(5)

    # ...and the immediately-preceding move must have been a pawn advancing
    # two squares on the destination file. If this is the case,
    # game.en_passant_file will equal the destination file.
    game.en_passant_file == new_x
  end
end
