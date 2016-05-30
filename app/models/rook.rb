class Rook < Piece

  def valid_move?(new_x, new_y)
    return false if off_board?(new_x, new_y)
    return false if current_square?(new_x, new_y)

    x_offset, y_offset = movement_by_axis(new_x, new_y)

    # If a move is along a rank or file, x_offset or y_offset needs to be zero.
    return false unless x_offset == 0 || y_offset == 0
    return false if obstructed?(new_x, new_y)
    true
  end

end
