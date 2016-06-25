module Movable
  extend ActiveSupport::Concern

  # If real_move is false, the move will be undone regardless of legality.
  # Either way, move_to! will return true if the move is fully legal,
  # and false otherwise.
  def move_to!(new_x, new_y, real_move = true)
    return false unless game.current_player == color
    return false unless valid_move?(new_x, new_y)

    if (destination_piece = game.piece_at(new_x, new_y))
      return capture_piece!(new_x, new_y, destination_piece, real_move)
    end
    
    update_piece_attributes(new_x, new_y, real_move)
  end

  private

  def capture_piece!(new_x, new_y, destination_piece, real_move)
    # If the destination piece is friendly, reject the move.
    # Otherwise, remove the destination piece for pending capture.
    return false if destination_piece.color == color
    capturee_location = [destination_piece.x_coord, destination_piece.y_coord]

    # Move the tentatively-captured piece to a "square" that
    # can't affect the actual board.
    destination_piece.update_attributes!(x_coord: 500, y_coord: 100)
    update_piece_attributes(new_x,
                            new_y,
                            real_move,
                            destination_piece,
                            capturee_location)
  end

  def update_piece_attributes(new_x,
                              new_y,
                              real_move,
                              destination_piece = nil,
                              capturee_location = nil)
    original_status = [x_coord, y_coord, moved]

    update_attributes!(x_coord: new_x, y_coord: new_y, moved: true)

    illegal_move = game.in_check?(color)

    # If the move is illegal or not real, return the pieces to their original
    # positions. Return the appropriate boolean for whether the move could
    # have been made.
    if illegal_move || !real_move
      reset_pieces!(original_status, destination_piece, capturee_location)
      return !illegal_move
    end

    # If this point is reached, move will be finalized.
    destination_piece && destination_piece.destroy

    update_game_attributes(destination_piece)
  end

  def update_game_attributes(captured_piece)
    update_move_rule_count(captured_piece)

    # If the move is not being made by a pawn, en passant capture is not
    # possible on the next move. If it is being made by a pawn, the move_to!
    # method in the Pawn class will set this value appropriately.
    game.update_attribute(:en_passant_file, nil) unless is_a? Pawn

    # Assign turn to the other player after a successful move.
    game.switch_players!

    game.game_over?

    true
  end

  def reset_pieces!(original_status, destination_piece, capturee_location)
    update_attributes!(x_coord: original_status[0],
                       y_coord: original_status[1],
                       moved: original_status[2])
    destination_piece && destination_piece.update_attributes!(
      x_coord: capturee_location[0],
      y_coord: capturee_location[1]
    )
  end

  def update_move_rule_count(captured_piece)
    if captured_piece || is_a?(Pawn)
      game.update_attribute(:move_rule_count, 0)
    else
      game.increment!(:move_rule_count)
    end
  end
end
