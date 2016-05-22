class Game < ActiveRecord::Base
  belongs_to :user
  has_one :enrollment
  has_one :black_player, through: :enrollment, source: :user
  has_many :pieces

  delegate :pawns, :rooks, :knights, :bishops, :queens, :kings, to: :pieces
end
