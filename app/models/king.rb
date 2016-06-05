class King < Piece
  # This method does not disallow a king from moving into check.
  def valid_move?(new_x, new_y)
    return false if off_board?(new_x, new_y)
    return false if current_square?(new_x, new_y)

    x_offset, y_offset = movement_by_axis(new_x, new_y)
    return true if (-1..1).cover?(x_offset) && (-1..1).cover?(y_offset)

    valid_castling?(new_x, new_y)
  end

  def valid_castling?(new_x, new_y)
    return false if moved?
    return false unless nth_rank(1) == new_y
    return false unless new_x == 3 || new_x == 7
    rook_file(new_x, new_y)
  end

  def nth_rank(n)
    color == 'white' ? n : 9 - n
  end

  def rook_file(new_x, new_y)
    rook_file = new_x == 3 ? 1 : 8
    rook = game.piece_at(rook_file, new_y)
    return false if rook.moved?
    return false if obstructed?(rook_file, new_y)
    true
  end
end
