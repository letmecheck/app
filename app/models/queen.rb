class Queen < Piece
  def valid_move?(new_x, new_y)
    return false unless super
    return false unless linear_move?(new_x, new_y)
    !obstructed?(new_x, new_y)
  end
end
