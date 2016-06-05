class King < Piece
  # This method does not yet consider castling, and does not
  # disallow a king from moving into check.
  def valid_move?(new_x, new_y)
    return false if off_board?(new_x, new_y)
    return false if current_square?(new_x, new_y)

    x_offset, y_offset = movement_by_axis(new_x, new_y)
    return true if (-1..1).cover?(x_offset) && (-1..1).cover?(y_offset)

    valid_castling?(new_x, new_y)
  end

  def valid_castling?(new_x, new_y)
    rook_file = 1 if new_x == 3
    rook_file = 8 if new_x == 7
    return false if obstructed?(rook_file, new_y)
  end
end
