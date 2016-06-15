class Rook < Piece
  def valid_move?(new_x, new_y)
    # x_offset, y_offset = movement_by_axis(new_x, new_y)

    # If a move is along a rank or file, x_offset or y_offset needs to be zero.
    return false if diagonal_move?(new_x, new_y)
    super
  end
end
