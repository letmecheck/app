class Knight < Piece
  def valid_move?(destination_x, destination_y)
    # Check to see if destination square is the same as origin square
    super

    x_offset, y_offset = movement_by_axis(destination_x, destination_y)
    x_offset.abs == 2 && y_offset.abs == 1 || x_offset.abs == 1 && y_offset.abs == 2
  end
end
