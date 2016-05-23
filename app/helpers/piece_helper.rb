# Note: the find_all_pieces helper relies on the current game existing in the
# instance variable @game. If it ends up being somewhere else, please change
# that method's second line accordingly.
module PieceHelper
  def obstructed?(current_x, current_y, destination_x, destination_y)
    # Sanity-check the prospective move.
    linear_move?(current_x, current_y, destination_x, destination_y)

    # Set delta_x and delta_y to -1, 0, or 1, such that adding them to
    # current_x and current_y will move one square toward the destination.

    delta_x = destination_x <=> current_x
    delta_y = destination_y <=> current_y

    # Move toward the destination one square at a time, stopping and returning
    # true if an obstructing piece is present. Return false upon successfully
    # reaching the destination.

    piece_locations = find_all_pieces

    loop do
      current_x += delta_x
      current_y += delta_y

      return false if current_x == destination_x && current_y == destination_y

      return true if piece_locations.include? [current_x, current_y]
    end
  end

  private

  def linear_move?(current_x, current_y, destination_x, destination_y)
    # Verify that origin and destination squares are valid board squares.
    squares_on_board?(current_x, current_y, destination_x, destination_y)

    # Determine the magnitude of movement along each axis.
    x_movement = (destination_x - current_x).abs
    y_movement = (destination_y - current_y).abs

    if x_movement == 0 && y_movement == 0
      raise 'Piece is already on destination square'
    end

    # If a move is along a rank or file, x_movement or y_movement will be zero.
    # If a move is along a diagonal, x_movement and y_movement will be equal.

    unless x_movement == 0 || y_movement == 0 || x_movement == y_movement
      raise 'Destination is not on the same rank, file, or diagonal as origin.'
    end
    true
  end

  def squares_on_board?(current_x, current_y, destination_x, destination_y)
    unless (1..8).cover?(current_x) && (1..8).cover?(current_y)
      raise 'Origin square is not on the board'
    end

    unless (1..8).cover?(destination_x) && (1..8).cover?(destination_y)
      raise 'Destination square is not on the board'
    end
    true
  end

  def find_all_pieces
    locations = []
    @game.pieces.each do |piece|
      locations << [piece.x_coord, piece.y_coord]
    end
    locations
  end
end
