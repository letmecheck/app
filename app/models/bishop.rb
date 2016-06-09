class Bishop < Piece
  def valid_move?(new_x, new_y)
    return false if off_board?(new_x, new_y)
    return false if current_square?(new_x, new_y)
    return false unless diagonal_move?(new_x, new_y)
    !obstructed?(new_x, new_y)
  end
end
