require 'rails_helper'

RSpec.describe Piece, type: :model do
  describe 'off_board?' do
    context 'when called by white pawn' do
      before(:each) do
        @game = Game.create
        @game.pieces.each(&:destroy)
        @white_pawn = Pawn.create(x_coord: 8, y_coord: 2, color: 'white')
        @white_rook = Rook.create(x_coord: 1, y_coord: 1, color: 'white')
        @game.pieces << @white_pawn
        @game.pieces << @white_rook
        @game.kings.create!(x_coord: 5, y_coord: 1, color: 'white')
        @game.kings.create!(x_coord: 5, y_coord: 8, color: 'black')
      end

      context 'A pawn is not permitted to move off the board' do
        it 'returns false if attempting to move off the board' do
          @white_pawn.move_to!(8, 4)
          expect(@white_pawn.move_to!(8, 4)).to be(false)
        end
      end
    end
  end

  describe 'current_square?' do
    context 'A rook is picked up and placed on the same square it started' do
      before(:each) do
        @game = Game.create
        @game.pieces.each(&:destroy)
        @white_pawn = Pawn.create(x_coord: 8, y_coord: 2, color: 'white')
        @white_rook = Rook.create(x_coord: 1, y_coord: 1, color: 'white')
        @game.pieces << @white_pawn
        @game.pieces << @white_rook
      end
      context 'picking up the rook and placing it on the same square' do
        it 'returns true if the turn still belongs to White' do
          @white_rook.move_to!(1, 1)
          expect(@white_rook.x_coord).to eq(1)
          expect(@white_rook.y_coord).to eq(1)
          expect(@game.white?).to be(true)
        end
      end
    end
  end

  describe '.has_valid_move?' do
    it 'works properly when check is not a factor' do
      @game = Game.create!
      @white_king = @game.piece_at(5, 1)
      @black_king = @game.piece_at(5, 8)
      @white_pawn_5 = @game.piece_at(5, 2)
      @black_pawn_5 = @game.piece_at(5, 7)
      @white_knight = @game.piece_at(2, 1)
      @black_knight = @game.piece_at(2, 8)
      @white_rook = @game.piece_at(1, 1)
      @black_rook = @game.piece_at(1, 8)
      @white_bishop = @game.piece_at(3, 1)
      @black_bishop = @game.piece_at(3, 8)
      @white_queen = @game.piece_at(4, 1)
      @black_queen = @game.piece_at(4, 8)

      expect(@white_queen.can_move?).to be false
      expect(@white_king.can_move?).to be false
      expect(@white_pawn_5.can_move?).to be true
      expect(@white_pawn_5.move_to!(5, 4)).to be true

      expect(@black_queen.can_move?).to be false
      expect(@black_king.can_move?).to be false
      expect(@black_pawn_5.can_move?).to be true
      expect(@black_pawn_5.move_to!(5, 5)).to be true

      expect(@white_pawn_5.can_move?).to be false
      expect(@game.piece_at(1, 2).move_to!(1, 3)).to be true

      expect(@black_pawn_5.can_move?).to be false
      expect(@game.piece_at(1, 7).move_to!(1, 6)).to be true

      expect(@white_knight.can_move?).to be true
      expect(@game.piece_at(3, 2).move_to!(3, 3)).to be true

      expect(@black_knight.can_move?).to be true
      expect(@game.piece_at(3, 7).move_to!(3, 6)).to be true

      expect(@white_knight.can_move?).to be false
      expect(@game.piece_at(8, 1).can_move?).to be false
      expect(@white_rook.can_move?).to be true
      expect(@white_rook.move_to!(1, 2)).to be true

      expect(@black_knight.can_move?).to be false
      expect(@game.piece_at(8, 8).can_move?).to be false
      expect(@black_rook.can_move?).to be true
      expect(@black_rook.move_to!(1, 7)).to be true

      expect(@white_bishop.can_move?).to be false
      expect(@game.piece_at(2, 2).move_to!(2, 4)).to be true

      expect(@black_bishop.can_move?).to be false
      expect(@game.piece_at(2, 7).move_to!(2, 5)).to be true

      expect(@white_bishop.can_move?).to be true
      expect(@white_queen.can_move?).to be true
      expect(@white_bishop.move_to!(2, 2)).to be true

      expect(@black_bishop.can_move?).to be true
      expect(@black_queen.can_move?).to be true
    end

    it 'rejects moves that leave the king in check' do
      @game = Game.create!

      # Set up a variant of the 4-move checkmate sometimes known as
      # "blitzkreig" or the "scholar's mate".
      expect(@game.piece_at(5, 2).move_to!(5, 4)).to be true
      expect(@game.piece_at(5, 7).move_to!(5, 5)).to be true
      expect(@game.piece_at(6, 1).move_to!(3, 4)).to be true
      expect(@game.piece_at(6, 8).move_to!(3, 5)).to be true
      expect(@game.piece_at(4, 1).move_to!(8, 5)).to be true
      expect(@game.piece_at(7, 8).move_to!(8, 6)).to be true
      expect(@game.piece_at(8, 5).move_to!(6, 7)).to be true

      # Black's only legal move is using the knight at (8, 6) to
      # capture the white queen at (6, 7)
      expect(@game.piece_at(5, 8).can_move?).to be false
      expect(@game.piece_at(1, 7).can_move?).to be false
      expect(@game.piece_at(1, 8).can_move?).to be false
      expect(@game.piece_at(2, 8).can_move?).to be false
      expect(@game.piece_at(3, 8).can_move?).to be false
      expect(@game.piece_at(4, 8).can_move?).to be false
      expect(@game.piece_at(8, 6).can_move?).to be true
    end
  end

  describe '.update_game_attributes' do
    it 'updates the move_rule_count properly' do
      @game = Game.create!
      expect(@game.move_rule_count).to eq 0
      @game.piece_at(5, 2).move_to!(5, 4)
      expect(@game.move_rule_count).to eq 0
      @game.piece_at(5, 7).move_to!(5, 5)
      @game.piece_at(7, 1).move_to!(8, 3)
      @game.piece_at(7, 8).move_to!(8, 6)
      @game.piece_at(2, 1).move_to!(1, 3)
      expect(@game.move_rule_count).to eq 3
      @game.piece_at(1, 7).move_to!(1, 6)
      expect(@game.move_rule_count).to eq 0
      @game.piece_at(4, 1).move_to!(8, 5)
      @game.piece_at(8, 6).move_to!(7, 8)
      expect(@game.move_rule_count).to eq 2
      @game.piece_at(8, 5).move_to!(6, 7)
      expect(@game.move_rule_count).to eq 0
    end
  end
end
