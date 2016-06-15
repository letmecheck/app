require 'rails_helper'

RSpec.describe King, type: :model do
  describe '.valid_move?' do
    context 'when called by white king' do
      before(:each) do
        @game = Game.create
        @game.pieces.each(&:destroy)
        @white_king = King.create(x_coord: 5, y_coord: 1, color: 'white')
        @white_rook = Rook.create(x_coord: 1, y_coord: 1, color: 'white')
        @game.pieces << @white_king
        @game.pieces << @white_rook
      end

      context 'castling move not permitted if the king has moved previously' do
        it 'returns false after attempting to castle' do
          @white_king.move_to!(5, 2)
          @white_king.move_to!(5, 1)
          expect(@white_king.move_to!(3, 1)).to be(false)
        end
      end

      context 'castling not permitted unless the king moves 2 spaces along the same rank' do
        it 'returns false after moving the white king 3 squares' do
          expect(@white_king.move_to!(2, 1)).to be(false)
        end
      end
    end

    context 'when called by black king' do
      before(:each) do
        @game = Game.create
        @game.black!
        @game.pieces.each(&:destroy)
        @black_king = King.create(x_coord: 5, y_coord: 8, color: 'black')
        @black_rook = Rook.create(x_coord: 8, y_coord: 8, color: 'black')
        @white_pawn = Pawn.create(x_coord: 8, y_coord: 2, color: 'white')
        @game.pieces << @white_pawn
        @game.pieces << @black_king
        @game.pieces << @black_rook
      end

      context 'castling move not permitted if the king has moved previously' do
        it 'returns false after attempting to castle' do
          @black_king.move_to!(6, 7)
          @white_pawn.move_to!(8, 3)
          @black_king.move_to!(5, 8)
          expect(@black_king.move_to!(7, 8)).to be(false)
        end
      end

      context 'castling not permitted unless the king moves 2 spaces along the same rank' do
        it 'returns false after moving the black king 3 squares' do
          expect(@black_king.move_to!(8, 8)).to be(false)
        end
      end
    end
  end

  describe '.move_to!' do
    context 'when called by white king' do
      it 'moves rook to kingside castled position' do
        game = Game.create
        game.pieces.each(&:destroy)
        white_king = King.create(x_coord: 5, y_coord: 1, color: 'white')
        white_rook = Rook.create(x_coord: 8, y_coord: 1, color: 'white')
        game.pieces << white_king
        game.pieces << white_rook

        white_king.move_to!(7, 1)
        white_rook.reload
        expect(white_rook.x_coord).to eq(6)
      end
    end

    context 'when called by white king' do
      it 'moves rook to queenside castled position' do
        game = Game.create
        game.pieces.each(&:destroy)
        white_king = King.create(x_coord: 5, y_coord: 1, color: 'white')
        white_rook = Rook.create(x_coord: 1, y_coord: 1, color: 'white')
        game.pieces << white_king
        game.pieces << white_rook

        white_king.move_to!(3, 1)
        white_rook.reload
        expect(white_rook.x_coord).to eq(4)
      end
    end

    context 'when called by black king' do
      it 'moves rook to kingside castled position' do
        game = Game.create
        game.pieces.each(&:destroy)
        black_king = King.create(x_coord: 5, y_coord: 8, color: 'black')
        black_rook = Rook.create(x_coord: 8, y_coord: 8, color: 'black')
        game.pieces << black_king
        game.pieces << black_rook

        black_king.move_to!(7, 8)
        black_rook.reload
        expect(black_rook.x_coord).to eq(6)
      end
    end

    context 'when called by black king' do
      it 'moves rook to queenside castled position' do
        game = Game.create
        game.pieces.each(&:destroy)
        black_king = King.create(x_coord: 5, y_coord: 8, color: 'black')
        black_rook = Rook.create(x_coord: 1, y_coord: 8, color: 'black')
        game.pieces << black_king
        game.pieces << black_rook

        black_king.move_to!(3, 8)
        black_rook.reload
        expect(black_rook.x_coord).to eq(4)
      end
    end
  end

  describe 'rook_requirements_met?' do
    context 'for white' do
      before(:each) do
        @game = Game.create
        @game.pieces.each(&:destroy)
        @white_king = King.create(x_coord: 5, y_coord: 1, color: 'white')
        @white_rook = Rook.create(x_coord: 8, y_coord: 1, color: 'white')
        @game.pieces << @white_king
        @game.pieces << @white_rook
      end

      context 'Rook has moved, and its original square is unoccupied' do
        it 'returns false' do
          @white_rook.move_to!(8, 2)
          expect(@white_king.valid_move?(7, 1)).to eq(false)
        end
      end

      context 'Rook has moved and another piece is in its original position' do
        it 'returns false' do
          white_bishop = Bishop.create(x_coord: 8, y_coord: 1, color: 'white')
          white_bishop.moved?
          @white_rook.move_to!(8, 2)
          expect(@white_king.valid_move?(7, 1)).to eq(false)
        end
      end

      context 'when the rook has moved and returned to its original position' do
        it 'returns false' do
          @white_rook.move_to!(8, 2)
          @white_rook.move_to!(8, 1)
          expect(@white_king.valid_move?(7, 1)).to eq(false)
        end
      end

      context 'neither king nor rook have moved, castling not permitted since path is obstructed by knight' do
        it 'returns false' do
          white_knight = @game.knights.create(x_coord: 7, y_coord: 1, color: 'white')
          white_knight.moved?
          expect(@white_king.valid_move?(7, 1)).to eq(false)
        end
      end

      context 'neither king nor rook have moved, but path obstructed by bishop' do
        it 'returns true' do
          white_bishop = @game.bishops.create(x_coord: 6, y_coord: 1, color: 'white')
          white_bishop.moved?
          expect(@white_king.valid_move?(7, 1)).to be(false)
        end
      end
    end

    context 'for black' do
      before(:each) do
        @game = Game.create
        @game.pieces.each(&:destroy)
        @black_king = King.create(x_coord: 5, y_coord: 8, color: 'black')
        @black_rook = Rook.create(x_coord: 1, y_coord: 8, color: 'black')
        @game.pieces << @black_king
        @game.pieces << @black_rook
        @white_pawn = Pawn.create(x_coord: 7, y_coord: 2, color: 'white')
        @game.pieces << @white_pawn
      end

      context 'Rook has moved, and its original square is unoccupied' do
        it 'returns false' do
          @white_pawn.move_to!(7, 3)
          @black_rook.move_to!(1, 7)
          @white_pawn.move_to!(7, 4)
          expect(@black_king.valid_move?(3, 8)).to eq(false)
        end
      end

      context 'Rook has moved and another piece is in its original position' do
        it 'returns false' do
          @black_rook.move_to!(1, 7)
          @white_pawn.move_to!(7, 5)
          black_queen = Queen.create(x_coord: 8, y_coord: 1, color: 'black')
          black_queen.moved?
          expect(@black_king.valid_move?(3, 8)).to eq(false)
        end
      end

      context 'when the rook has moved and returned to its original position' do
        it 'returns false' do
          @black_rook.move_to!(1, 4)
          @white_pawn.move_to!(7, 6)
          @black_rook.move_to!(1, 8)
          @white_pawn.move_to!(7, 7)
          expect(@black_king.valid_move?(3, 8)).to eq(false)
        end
      end

      context 'castling not permitted since path is obstructed by queen' do
        it 'returns false' do
          black_queen = @game.queens.create(x_coord: 4, y_coord: 8, color: 'black')
          black_queen.moved?
          expect(@black_king.valid_move?(3, 8)).to eq(false)
        end
      end

      context 'castling not permitted since path is obstructed by bishop' do
        it 'returns false' do
          black_bishop = @game.bishops.create(x_coord: 3, y_coord: 8, color: 'black')
          black_bishop.moved?
          expect(@black_king.valid_move?(3, 8)).to eq(false)
        end
      end

      context 'castling not permitted since path is obstructed by knight' do
        it 'returns false' do
          black_knight = @game.knights.create(x_coord: 2, y_coord: 8, color: 'black')
          black_knight.moved?
          expect(@black_king.valid_move?(3, 8)).to eq(false)
        end
      end
    end
  end

  describe 'king_traversal_under_attack?' do
    context 'for black' do
      before(:each) do
        @game = Game.create
        @game.pieces.each(&:destroy)
        @black_king = King.create(x_coord: 5, y_coord: 8, color: 'black')
        @black_rook = Rook.create(x_coord: 1, y_coord: 8, color: 'black')
        @game.pieces << @black_king
        @game.pieces << @black_rook
      end

      context 'The king is directly threatened' do
        it 'returns true' do
          white_rook = @game.rooks.create(x_coord: 5, y_coord: 4, color: 'white')
          white_rook.moved?
          expect(@black_king.valid_move?(3, 8)).to be(false)
        end
      end

      context 'The 1st square the king must traverse for castling is threatened' do
        it 'returns true' do
          white_bishop = @game.bishops.create(x_coord: 2, y_coord: 6, color: 'white')
          white_bishop.moved?
          expect(@black_king.valid_move?(3, 8)).to be(false)
        end
      end

      context 'The 2nd square the king must traverse for castling is threatened' do
        it 'returns true' do
          white_queen = @game.queens.create(x_coord: 3, y_coord: 6, color: 'white')
          white_queen.moved?
          expect(@black_king.valid_move?(3, 8)).to be(false)
        end
      end
    end

    context 'for white' do
      before(:each) do
        @game = Game.create
        @game.pieces.each(&:destroy)
        @white_king = King.create(x_coord: 5, y_coord: 1, color: 'white')
        @white_rook = Rook.create(x_coord: 8, y_coord: 1, color: 'white')
        @game.pieces << @white_king
        @game.pieces << @white_rook
      end

      context 'The king is directly threatened' do
        it 'returns true' do
          black_knight = @game.knights.create(x_coord: 4, y_coord: 3, color: 'black')
          black_knight.moved?
          expect(@white_king.valid_move?(7, 1)).to be(false)
        end
      end

      context 'The 1st square the king must traverse for castling is under threat' do
        it 'returns true' do
          black_pawn = @game.pawns.create(x_coord: 7, y_coord: 2, color: 'black')
          black_pawn.moved?
          expect(@white_king.valid_move?(7, 1)).to be(false)
        end
      end

      context 'The 2nd square the king must traverse for castling is threatened' do
        it 'returns true' do
          black_rook = @game.rooks.create(x_coord: 7, y_coord: 8, color: 'black')
          black_rook.moved?
          expect(@white_king.valid_move?(7, 1)).to be(false)
        end
      end
    end
  end
end
