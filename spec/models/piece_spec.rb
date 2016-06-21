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
end
