class King < Piece
  # This method does not yet consider castling.
  def valid_move?(new_x, new_y)
    return false if off_board?(new_x, new_y)
    return false if current_square?(new_x, new_y)

    x_offset, y_offset = movement_by_axis(new_x, new_y)
    return false unless (-1..1).cover?(x_offset) && (-1..1).cover?(y_offset)

    true
  end
end
