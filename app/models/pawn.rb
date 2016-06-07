class Pawn < Piece
  def valid_move?(new_x, new_y)
    return false if off_board?(new_x, new_y)

    offset = movement_by_axis(new_x, new_y)

    offset[1] *= -1 if color == 'black'

    return valid_standard_move?(new_x, new_y) if offset == [0, 1]

    return valid_double_move?(new_x, new_y) if offset == [0, 2]

    return valid_capture?(new_x, new_y) if [[-1, 1], [1, 1]].include? offset

    false
  end

  private

  def valid_standard_move?(new_x, new_y)
    !game.piece_at(new_x, new_y)
  end

  def valid_double_move?(new_x, new_y)
    origin_row = (color == 'white') ? 2 : 7
    passed_row = (color == 'white') ? 3 : 6

    return false unless y_coord == origin_row
    return false if game.piece_at(new_x, passed_row)
    return false if game.piece_at(new_x, new_y)
    true
  end

  def valid_capture?(new_x, new_y)
    destination_piece = game.piece_at(new_x, new_y)
    destination_piece.present? && destination_piece.color != color
  end
end
