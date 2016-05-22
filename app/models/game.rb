class Game < ActiveRecord::Base
  belongs_to :user
  has_one :enrollment
  has_one :black_player, through: :enrollment, source: :user
  has_many :pieces

  delegate :pawns, :rooks, :knights, :bishops, :queens, :kings, to: :pieces

  after_create :setup_board!

  private

  def setup_board!
    Rook.create(game_id: id, x_coord: 0, y_coord: 0, color: 'white')
    Rook.create(game_id: id, x_coord: 7, y_coord: 0, color: 'white')

    Knight.create(game_id: id, x_coord: 1, y_coord: 0, color: 'white')
    Knight.create(game_id: id, x_coord: 6, y_coord: 0, color: 'white')

    Bishop.create(game_id: id, x_coord: 2, y_coord: 0, color: 'white')
    Bishop.create(game_id: id, x_coord: 5, y_coord: 0, color: 'white')

    Queen.create(game_id: id, x_coord: 3, y_coord: 0, color: 'white')
    King.create(game_id: id, x_coord: 4, y_coord: 0, color: 'white')

    (0..7).each do |position|
      Pawn.create(game_id: id, x_coord: position, y_coord: 1, color: 'white')
    end
  end
end
