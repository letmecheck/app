class CreatePieces < ActiveRecord::Migration[4.2]
  def change
    create_table :pieces do |t|
      t.references :game, index: true, foreign_key: true

      t.string     :piece_type  # pawn, rook, etc.
      t.string     :color

      t.integer    :x_coord   
      t.integer    :y_coord   
    end
  end
end
