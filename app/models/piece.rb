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

  def valid_move?
    # Implement this method in each subclass.
    # Keep this method here for the parent class, in case things go awry.
    raise 'Abstract method'
  end
end
