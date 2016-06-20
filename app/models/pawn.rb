class Pawn < Piece
  def valid_move?(new_x, new_y)
    return false unless super

    offset = movement_by_axis(new_x, new_y)

    offset[1] *= -1 if color == 'black'

    return valid_standard_move?(new_x, new_y) if offset == [0, 1]

    return valid_double_move?(new_x, new_y) if offset == [0, 2]

    return valid_capture?(new_x, new_y) if [[-1, 1], [1, 1]].include? offset
    false
  end

  # This is an addition to the move_to! method in the Piece model.
  # It destroys a pawn that has been captured en passant, determines whether
  # the current pawn is vulnerable to en passant capture, and adds a
  # placeholder for pawn promotion.
  def move_to!(new_x, new_y)
    # Make note of a pawn captured en passant. Don't destroy it until after
    # the call to super, which ensures that the move is valid.
    en_passant_victim = en_passant_capturee(new_x, new_y)

    # If the pawn is advancing two squares, it may be captured en passant on
    # the next move.
    en_passant_file = (new_y - y_coord).abs == 2 ? x_coord : nil

    # Call the Piece class's move_to! method. If it returns false, that means
    # it's rejecting the move. Make sure execution stops here in that case.
    return false unless super

    # Wait until after super has been called to update this. Otherwise, an en
    # passant capture would be rejected by super's call to valid_move?, which
    # would return false because en_passant_file has been updated to nil.
    game.update_attribute(:en_passant_file, en_passant_file)

    # Now, destroy a pawn captured en passant.
    en_passant_victim && en_passant_victim.destroy

    # TODO: Implement the promote! method.
    # promote! if y_coord == nth_rank(8)

    true
  end

  private

  def valid_standard_move?(new_x, new_y)
    !game.piece_at(new_x, new_y)
  end

  def valid_double_move?(new_x, new_y)
    return false unless y_coord == nth_rank(2)
    return false if game.piece_at(new_x, nth_rank(3))
    !game.piece_at(new_x, new_y)
  end

  def valid_capture?(new_x, new_y)
    # If there is a piece at the destination, the capture is valid if it's an
    # enemy piece, and invalid if friendly. Otherwise, determine whether an
    # en passant capture is possible.
    destination_piece = game.piece_at(new_x, new_y)

    return destination_piece.color != color if destination_piece

    # To make an en passant capture, the pawn must start on its fifth rank
    # (i.e., have a y_coord of 5 if white, or 4 if black)...
    return false unless y_coord == nth_rank(5)

    # ...and the immediately-preceding move must have been a pawn advancing
    # two squares on the destination file. If this is the case,
    # game.en_passant_file will equal the destination file.
    game.reload.en_passant_file == new_x
  end

  def en_passant_capturee(new_x, new_y)
    # If the pawn's x value is changing, the move must be a capture.
    # If the destination rank is the current player's sixth rank (the enemy's
    # third), and the last move was a two-square advance by a pawn on the
    # destination file, it must be en passant. In that case, capture the enemy
    # pawn, which is currently on the starting rank of the moving pawn.
    if new_x != x_coord &&
       new_y == nth_rank(6) &&
       game.reload.en_passant_file == new_x

      return game.piece_at(new_x, y_coord)
    end
    nil
  end
end
