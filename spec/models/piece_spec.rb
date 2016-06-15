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
      it 'returns true if a moved piece ends up on its current square' do
        expect(@white_rook.move_to!(1, 1)).to be(true)
      end
    end
  end
end
