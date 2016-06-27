class Rook < Piece
  def valid_move?(new_x, new_y)
    return false unless super
    x_offset, y_offset = movement_by_axis(new_x, new_y)

    # If a move is along a rank or file, x_offset or y_offset needs to be zero.
    return false unless  x_offset == 0 || y_offset == 0
    !obstructed?(new_x, new_y)
  end

  private

  def possible_offsets
    offsets = []
    1.upto(7) do |i|
      offsets += [[-i, 0], [i, 0], [0, -i], [0, i]]
    end
    offsets
  end
end
