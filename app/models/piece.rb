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

  def move_to!(new_x, new_y)
    return false unless game.current_player == color
    return false unless valid_move?(new_x, new_y)
    destination_piece = game.piece_at(new_x, new_y)

    # If the destination piece is friendly, reject the move.
    # Otherwise, capture the destination piece.
    if destination_piece
      return false if destination_piece.color == color
      destination_piece.destroy
    end

    update_game_attributes(new_x, new_y)
  end

  def update_game_attributes(new_x, new_y)
    # If the move is not being made by a pawn, en passant capture is not
    # possible on the next move. If it is being made by a pawn, the move_to!
    # method in the Pawn class will set this value appropriately.
    game.update_attribute(:en_passant_file, nil) unless is_a? Pawn

    update_attributes!(x_coord: new_x, y_coord: new_y, moved: true)

    # Assign turn to the other player after a successful move.
    game.switch_players!
  end

  def valid_move?(new_x, new_y)
    return false if current_square?(new_x, new_y)

    return false if off_board?(new_x, new_y)

    return false unless linear_move?(new_x, new_y) && piece_type != 'Pawn'

    !obstructed?(new_x, new_y) || piece_type == 'Knight'

    # Implement this method in each subclass.
    # Keep this method here for the parent class, in case things go awry.
    # raise 'Abstract method'
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

  # private  # Temporarily commented out for debugging.

  def linear_move?(new_x, new_y)
    x_offset, y_offset = movement_by_axis(new_x, new_y)

    # If a move is along a rank or file, x_offset or y_offset will be zero.
    # If a move is along a diagonal, their absolute values will be equal.

    x_offset == 0 || y_offset == 0 || diagonal_move?(new_x, new_y)
  end

  # Returns the potenial move's displacement along each axis.
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
