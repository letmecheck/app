class Bishop < Piece
  def valid_move?(new_x, new_y)
    return false unless diagonal_move?(new_x, new_y)
    super
  end
end
