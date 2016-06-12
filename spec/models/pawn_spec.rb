require 'rails_helper'

RSpec.describe Pawn, type: :model do
  context "when set up for en passant" do
    let(:game) { Game.create! }
    let(:white_pawn_2) { game.piece_at(2, 2) }
    let(:black_pawn_3) { game.piece_at(3, 7) }
    let(:white_pawn_5) { game.piece_at(5, 2) }
    let(:black_pawn_6) { game.piece_at(6, 7) }
    let(:white_knight) { game.piece_at(7, 1) }
    let(:black_knight) { game.piece_at(7, 8) }

    it "allows valid en passant capture" do
      white_pawn_2.move_to!(2, 4)
      black_knight.move_to!(8, 6)
      white_pawn_2.move_to!(2, 5)
      black_pawn_3.move_to!(3, 5)
      expect(white_pawn_2.valid_move?(3, 6)).to be true
      white_pawn_2.move_to!(3, 6)
      expect { black_pawn_3.reload }.to raise_error(
        ActiveRecord::RecordNotFound
      )
    end

    it "disallows e.p. capture after another move has been made" do
      black_pawn_6.move_to!(6, 5)
      white_knight.move_to!(8, 3)
      black_pawn_6.move_to!(6, 4)
      white_pawn_5.move_to!(5, 4)
      black_knight.move_to!(8, 6)
      white_knight.move_to!(7, 5)
      expect(black_pawn_6.valid_move?(5, 3)).to be false
      # This will work properly when valid_move? is required by move_to!:
      # expect(black_pawn_6.move_to!(5, 3)).to be false
      expect(white_pawn_5.reload.id).to be_a Integer
    end
  end
end
