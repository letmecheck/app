class Piece < ActiveRecord::Base
  belongs_to :game
  self.inheritance_column = :piece_type

  def self.piece_types
    %w(Pawn Rook Knight Bishop Queen King)
  end

  scope :pawns,   -> { where(piece_type: 'Pawn') }
  scope :rooks,   -> { where(piece_type: 'Rook') }
  scope :knights, -> { where(piece_type: 'Knight') }
  scope :bishops, -> { where(piece_type: 'Bishop') }
  scope :queens,  -> { where(piece_type: 'Queen') }
  scope :kings,   -> { where(piece_type: 'King') }

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

    destination_piece && destination_piece.destroy

    update_game_attributes
  end

  def update_game_attributes
    # If the move is not being made by a pawn, en passant capture is not
    # possible on the next move. If it is being made by a pawn, the move_to!
    # method in the Pawn class will set this value appropriately.
    game.update_attribute(:en_passant_file, nil) unless is_a? Pawn

    # Assign turn to the other player after a successful move.
    game.switch_players!

    opponent_color = color == 'white' ? 'black' : 'white'
    game.game_over unless game.player_can_move?(opponent_color)

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

  def valid_move?(new_x, new_y)
    return false if current_square?(new_x, new_y)

    return false if off_board?(new_x, new_y)

    # The rest of the logic is each Piece sub-class valid_move? method
    true
  end

  # Helper method for checkmate/stalemate determination.
  # Returns true if the piece has any fully-legal move, false otherwise.
  def can_move?
    possible_offsets.each do |offset|
      return true if move_to!(x_coord + offset[0],
                              y_coord + offset[1],
                              false)
    end
    false
  end

  def obstructed?(new_x, new_y)
    current_x = x_coord
    current_y = y_coord

    # Move toward the destination one square at a time, stopping and returning
    # true if an obstructing piece is present. Return false upon successfully
    # reaching the destination.

    loop do
      current_x += (new_x <=> current_x)
      current_y += (new_y <=> current_y)

      return false if current_x == new_x && current_y == new_y

      return true if game.piece_at(current_x, current_y)
    end
  end

  private

  def linear_move?(new_x, new_y)
    x_offset, y_offset = movement_by_axis(new_x, new_y)

    # If a move is along a rank or file, x_offset or y_offset will be zero.
    # If a move is along a diagonal, their absolute values will be equal.

    x_offset == 0 || y_offset == 0 || x_offset.abs == y_offset.abs
  end

  # Returns the potential move's displacement along each axis.
  def movement_by_axis(new_x, new_y)
    [(new_x - x_coord), (new_y - y_coord)]
  end

  def off_board?(new_x, new_y)
    (1..8).exclude?(new_x) || (1..8).exclude?(new_y)
  end

  def current_square?(new_x, new_y)
    new_x == x_coord && new_y == y_coord
  end

  def diagonal_move?(new_x, new_y)
    x_offset, y_offset = movement_by_axis(new_x, new_y)

    x_offset.abs == y_offset.abs
  end

  # Given the rank from the current player's perspective, returns the
  # corresponding y value. For example, pawns start on the player's second
  # rank, which is 2 for White and 7 for Black. Therefore, nth_rank(2)
  # returns 2 if the piece is white, and 7 if it's black.
  def nth_rank(n)
    color == 'white' ? n : 9 - n
  end
end
