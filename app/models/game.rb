class Game < ActiveRecord::Base
  enum current_player: [:white, :black]

  belongs_to :user
  has_many :pieces

  delegate :pawns, :rooks, :knights, :bishops, :queens, :kings, to: :pieces

  after_create :setup_board!

  def switch_players!
    if white?
      black!
    else
      white!
    end
  end

  # helper method to aid in determining the opponent's color
  # this returns the color of the player who does NOT have the current move
  def other_player
    white? ? 'black' : 'white'
  end

  # Helper method used to determine if a particular square is under potential attack.
  def square_threatened_by?(color, destination_x, destination_y)
    enemy_pieces = pieces.where(color: color)
    enemy_pieces.each do |piece|
      return true if piece.valid_move?(destination_x, destination_y)
    end
    false
  end

  # Helper method for in_check?
  def find_king(color)
    pieces.find_by(piece_type: 'King', color: color)
  end

  # Determine if the king is being moved into a position resulting in check.
  def in_check?(color)
    # Find the active player's king
    king = find_king(color)

    # Distinguish which pieces belong to the opponent.
    opponent_color = (color == 'white') ? 'black' : 'white'

    square_threatened_by?(opponent_color, king.x_coord, king.y_coord)
  end

  # Returns the Piece object located at the given square.
  def piece_at(x_coord, y_coord)
    pieces.find_by(x_coord: x_coord, y_coord: y_coord)
  end

  # helper method that aids in determining stalemate/checkmate
  def player_can_move?(color)
    player_pieces = pieces.where(color: color)
    player_pieces.each do |piece|
      return true if piece.can_move?
    end
    false
  end

  def game_over
    if in_check?(current_player)
      checkmate
    else
      stalemate
    end
  end

  private

  def checkmate
    # The current player is the one who is under checkmate
    update_attribute(:game_result, other_player)
    update_attribute(:game_over_reason, "checkmate")
  end

  def stalemate
    update_attribute(:game_result, "draw")
    update_attribute(:game_over_reason, "stalemate")
  end

  def setup_board!
    %w(white black).each do |color|
      y_coordinate = color == 'white' ? 1 : 8 # is color white y/n, if not then it's blk and y == 8
      create_rooks!(y_coordinate, color)
      create_knights!(y_coordinate, color)
      create_bishops!(y_coordinate, color)
      create_royalty!(y_coordinate, color)

      pawn_y_coordinate = color == 'white' ? 2 : 7
      (1..8).each do |position|
        pawns.create(x_coord: position, y_coord: pawn_y_coordinate, color: color, img: "#{color}_pawn.svg")
      end
    end
  end

  def create_rooks!(y_coordinate, color)
    rooks.create(x_coord: 1, y_coord: y_coordinate, color: color, img: "#{color}_rook.svg")
    rooks.create(x_coord: 8, y_coord: y_coordinate, color: color, img: "#{color}_rook.svg")
  end

  def create_knights!(y_coordinate, color)
    knights.create(x_coord: 2, y_coord: y_coordinate, color: color, img: "#{color}_knight.svg")
    knights.create(x_coord: 7, y_coord: y_coordinate, color: color, img: "#{color}_knight.svg")
  end

  def create_bishops!(y_coordinate, color)
    bishops.create(x_coord: 3, y_coord: y_coordinate, color: color, img: "#{color}_bishop.svg")
    bishops.create(x_coord: 6, y_coord: y_coordinate, color: color, img: "#{color}_bishop.svg")
  end

  def create_royalty!(y_coordinate, color)
    queens.create(x_coord: 4, y_coord: y_coordinate, color: color, img: "#{color}_queen.svg")
    kings.create(x_coord: 5, y_coord: y_coordinate, color: color, img: "#{color}_king.svg")
  end
end
