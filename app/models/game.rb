class Game < ActiveRecord::Base
  belongs_to :user
  has_many :pieces

  delegate :pawns, :rooks, :knights, :bishops, :queens, :kings, to: :pieces
end
