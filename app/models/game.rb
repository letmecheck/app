class Game < ActiveRecord::Base
  belongs_to :user
  has_many :pieces

  delegate :pawns, :rooks, :knights, :bishops, :queens, :kings, to: :pieces

  after_create :setup_board!

  # Returns the Piece object located at the given square.
  def piece_at(x_coord, y_coord)
    pieces.where(x_coord: x_coord, y_coord: y_coord).first
  end

  private

  def setup_board!
    %w(white black).each do |color|
      y_coordinate = color == 'white' ? 1 : 8 # is color white y/n, if not then it's blk and y == 8
      Rook.create(game_id: id, x_coord: 1, y_coord: y_coordinate, color: color, img: "#{color}_rook.svg")
      Knight.create(game_id: id, x_coord: 2, y_coord: y_coordinate, color: color, img: "#{color}_knight.svg")
      Bishop.create(game_id: id, x_coord: 3, y_coord: y_coordinate, color: color, img: "#{color}_bishop.svg")
      Queen.create(game_id: id, x_coord: 4, y_coord: y_coordinate, color: color, img: "#{color}_queen.svg")
      King.create(game_id: id, x_coord: 5, y_coord: y_coordinate, color: color, img: "#{color}_king.svg")
      Bishop.create(game_id: id, x_coord: 6, y_coord: y_coordinate, color: color, img: "#{color}_bishop.svg")
      Knight.create(game_id: id, x_coord: 7, y_coord: y_coordinate, color: color, img: "#{color}_knight.svg")
      Rook.create(game_id: id, x_coord: 8, y_coord: y_coordinate, color: color, img: "#{color}_rook.svg")

      pawn_y_coordinate = color == 'white' ? 2 : 7
      (1..8).each do |position|
        Pawn.create(game_id: id, x_coord: position, y_coord: pawn_y_coordinate, color: color, img: "#{color}_pawn.svg")
      end
    end
  end
end
