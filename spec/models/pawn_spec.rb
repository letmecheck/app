require 'rails_helper'

RSpec.describe Pawn, type: :model do
  describe '.valid_move?' do
    context 'when called by white pawn' do
      before(:each) do
        game = Game.create
        game.pieces.each(&:destroy)
        @white_pawn = Pawn.create(x_coord: 2, y_coord: 2, color: 'white')
        game.pieces << @white_pawn
      end

      context "move the pawn diagonally" do
        it 'returns false if attempting to move to an empty square' do
          @white_pawn.valid_move?(3, 3)
          expect(@white_pawn.valid_move?(3, 3)).to be(false)
        end
      end
    end
  end

  describe '.move_to!' do
    context 'when called by white pawn' do
      before(:each) do
        game = Game.create
        game.pieces.each(&:destroy)
        @white_pawn = Pawn.create(x_coord: 1, y_coord: 2, color: 'white')
        game.pieces << @white_pawn
      end

      context "move the pawn diagonally" do
        it 'returns false if attempting to move to an empty square' do
          @white_pawn.move_to!(2, 3)
          expect(@white_pawn.move_to!(2, 3)).to be(false)
        end
      end
    end
  end

  context "when set up for en passant" do
    let(:game) { Game.create! }
    let(:white_pawn_2) { game.piece_at(2, 2) }
    let(:black_pawn_1) { game.piece_at(1, 7) }
    let(:white_pawn_5) { game.piece_at(5, 2) }
    let(:black_pawn_6) { game.piece_at(6, 7) }
    let(:white_knight) { game.piece_at(7, 1) }
    let(:black_knight) { game.piece_at(7, 8) }
    let(:black_pawn_3) { game.piece_at(3, 7) }
    let(:white_bishop) { game.piece_at(6, 1) }

    it "allows valid en passant capture by White" do
      expect(white_pawn_2.valid_move?(2, 4)).to be true
      expect(white_pawn_2.move_to!(2, 4)).to be true
      # Inconsequential move to bypass Black's turn:
      expect(black_knight.move_to!(8, 6)).to be true
      expect(white_pawn_2.move_to!(2, 5)).to be true
      # Two-square advance:
      expect(black_pawn_1.move_to!(1, 5)).to be true
      # Capture:
      expect(white_pawn_2.valid_move?(1, 6)).to be true
      white_pawn_2.move_to!(1, 6)
      expect { black_pawn_1.reload }.to raise_error(
        ActiveRecord::RecordNotFound
      )
      expect(white_pawn_2.x_coord).to eq 1
      expect(white_pawn_2.y_coord).to eq 6
    end

    it "allows valid en passant capture by Black" do
      # Inconsequential move to bypass White's turn:
      white_knight.move_to!(8, 3)
      black_pawn_6.move_to!(6, 5)
      # Ditto:
      white_knight.move_to!(7, 1)
      black_pawn_6.move_to!(6, 4)
      # Two-square advance:
      white_pawn_5.move_to!(5, 4)
      # Capture:
      expect(black_pawn_6.valid_move?(5, 3)).to be true
      black_pawn_6.move_to!(5, 3)
      expect { white_pawn_5.reload }.to raise_error(
        ActiveRecord::RecordNotFound
      )
      expect(black_pawn_6.x_coord).to eq 5
      expect(black_pawn_6.y_coord).to eq 3
    end

    it "disallows e.p. capture after another move has been made" do
      # Inconsequential move to bypass White's turn:
      white_knight.move_to!(8, 3)
      black_pawn_6.move_to!(6, 5)
      # Ditto:
      white_knight.move_to!(7, 1)
      black_pawn_6.move_to!(6, 4)
      # Two-square advance:
      white_pawn_5.move_to!(5, 4)
      # Completely-unrelated moves by each player:
      black_knight.move_to!(8, 6)
      white_knight.move_to!(8, 3)
      # Invalid capture:
      expect(black_pawn_6.valid_move?(5, 3)).to be false
      expect(black_pawn_6.move_to!(5, 3)).to be false
      expect(white_pawn_5.reload.id).to be_a Integer
    end

    it "disallows e.p. capture by a non-pawn" do
      white_pawn_5.move_to!(5, 4)
      # Inconsequential move to bypass Black's turn:
      black_knight.move_to!(8, 6)
      white_bishop.move_to!(2, 5)
      # Two-square advance:
      black_pawn_3.move_to!(3, 5)
      # Invalid capture:
      white_bishop.move_to!(3, 6)
      expect(black_pawn_3.reload.id).to be_a Integer
    end

    it "disallows e.p. capture without a two-square advance" do
      white_pawn_2.move_to!(2, 4)
      # One-square advance:
      black_pawn_1.move_to!(1, 6)
      white_pawn_2.move_to!(2, 5)
      # A second one-square advance:
      black_pawn_1.move_to!(1, 5)
      # Invalid capture:
      expect(white_pawn_2.valid_move?(1, 6)).to be false
      expect(white_pawn_2.move_to!(1, 6)).to be false
      expect(black_pawn_1.reload.id).to be_a Integer
    end
  end
end
