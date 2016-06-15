class Bishop < Piece
  def valid_move?(destination_x, destination_y)
    return false unless diagonal_move?(destination_x, destination_y)
    super
  end
end
