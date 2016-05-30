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

  def move_to!(destination_x, destination_y)
    destination_piece = game.piece_at(destination_x, destination_y)

    if destination_piece
      return false if destination_piece.color == color
      destination_piece.destroy
    end

    update_attributes!(x_coord: destination_x, y_coord: destination_y)
  end

  def valid_move?
    # Implement this method in each subclass.
    # Keep this method here for the parent class, in case things go awry.
    raise 'Abstract method'
  end

  def obstructed?(destination_x, destination_y)
    # Sanity-check the prospective move.
    error = bad_move_reason(destination_x, destination_y)
    raise error if error

    current_x = x_coord
    current_y = y_coord

    # Move toward the destination one square at a time, stopping and returning
    # true if an obstructing piece is present. Return false upon successfully
    # reaching the destination.

    loop do
      current_x += (destination_x <=> current_x)
      current_y += (destination_y <=> current_y)

      return false if current_x == destination_x && current_y == destination_y

      return true if game.piece_at(current_x, current_y)
    end
  end

  # private  # Temporarily commented out for debugging.

  def bad_move_reason(new_x, new_y)
    return 'Destination is not on board.' if off_board?(new_x, new_y)

    if current_square?(new_x, new_y)
      return 'Origin and destination are the same square.'
    end

    unless linear_move?(new_x, new_y)
      return 'Destination is not on same rank, file, or diagonal as origin.'
    end
    nil
  end

  def linear_move?(new_x, new_y)
    return false if current_square?(new_x, new_y)
    x_offset, y_offset = movement_by_axis(new_x, new_y)

    # If a move is along a rank or file, x_offset or y_offset will be zero.
    # If a move is along a diagonal, their absolute values will be equal.

    x_offset == 0 || y_offset == 0 || diagonal_move?(new_x, new_y)
  end

  # Returns the potenial move's displacement along each axis.
  def movement_by_axis(new_x, new_y)
    [(new_x - x_coord), (new_y - y_coord)]
  end

  def off_board?(x_value, y_value)
    (1..8).exclude?(x_value) || (1..8).exclude?(y_value)
  end

  def current_square?(x_value, y_value)
    x_value == x_coord && y_value == y_coord
  end

  def diagonal_move?(new_x, new_y)
    x_offset, y_offset = movement_by_axis(new_x, new_y)

    return true if x_offset.abs == y_offset.abs

    false
  end
end
