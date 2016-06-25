class Piece < ActiveRecord::Base
  belongs_to :game
  after_update :send_update_email
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

  include Movable

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
  
  def send_update_email
    NotificationMailer.notify_move_made(self).deliver
  end   

end
