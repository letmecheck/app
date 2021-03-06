class Queen < Piece
  def valid_move?(new_x, new_y)
    return false unless super
    return false unless linear_move?(new_x, new_y)
    !obstructed?(new_x, new_y)
  end

  private

  def possible_offsets
    offsets = []
    1.upto(7) do |i|
      offsets += [[-i, 0], [i, 0], [0, -i], [0, i]]
      offsets += [[-i, i], [-i, -i], [i, -i], [i, i]]
    end
    offsets
  end
end
