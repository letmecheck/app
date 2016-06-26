require 'rails_helper'

RSpec.describe Game, type: :model do
  describe '.player_can_move' do
    it 'works properly for checkmate' do
      white_user = FactoryGirl.create(:user)
      black_user = FactoryGirl.create(:user)
      @game = Game.create!

      # Fool's mate.
      expect(@game.player_can_move?('white')).to be true
      expect(@game.piece_at(6, 2).move_to!(6, 3)).to be true

      expect(@game.player_can_move?('black')).to be true
      expect(@game.piece_at(5, 7).move_to!(5, 5)).to be true

      expect(@game.player_can_move?('white')).to be true
      expect(@game.piece_at(7, 2).move_to!(7, 4)).to be true

      expect(@game.player_can_move?('black')).to be true
      expect(@game.piece_at(4, 8).move_to!(8, 4)).to be true

      expect(@game.player_can_move?('white')).to be false
    end

    it 'works properly for stalemate' do
      @game = Game.create!

      # Ten-move stalemate, as seen at
      # https://www.chess.com/article/view/quickest-stalemate-in-chess
      expect(@game.player_can_move?('white')).to be true
      expect(@game.piece_at(5, 2).move_to!(5, 3)).to be true
      expect(@game.player_can_move?('black')).to be true
      expect(@game.piece_at(1, 7).move_to!(1, 5)).to be true
      expect(@game.player_can_move?('white')).to be true
      expect(@game.piece_at(4, 1).move_to!(8, 5)).to be true
      expect(@game.player_can_move?('black')).to be true
      expect(@game.piece_at(1, 8).move_to!(1, 6)).to be true
      expect(@game.player_can_move?('white')).to be true
      expect(@game.piece_at(8, 5).move_to!(1, 5)).to be true
      expect(@game.player_can_move?('black')).to be true
      expect(@game.piece_at(8, 7).move_to!(8, 5)).to be true
      expect(@game.player_can_move?('white')).to be true
      expect(@game.piece_at(1, 5).move_to!(3, 7)).to be true
      expect(@game.player_can_move?('black')).to be true
      expect(@game.piece_at(1, 6).move_to!(8, 6)).to be true
      expect(@game.player_can_move?('white')).to be true
      expect(@game.piece_at(8, 2).move_to!(8, 4)).to be true
      expect(@game.player_can_move?('black')).to be true
      expect(@game.piece_at(6, 7).move_to!(6, 6)).to be true
      expect(@game.player_can_move?('white')).to be true
      expect(@game.piece_at(3, 7).move_to!(4, 7)).to be true
      expect(@game.player_can_move?('black')).to be true
      expect(@game.piece_at(5, 8).move_to!(6, 7)).to be true
      expect(@game.player_can_move?('white')).to be true
      expect(@game.piece_at(4, 7).move_to!(2, 7)).to be true
      expect(@game.player_can_move?('black')).to be true
      expect(@game.piece_at(4, 8).move_to!(4, 3)).to be true
      expect(@game.player_can_move?('white')).to be true
      expect(@game.piece_at(2, 7).move_to!(2, 8)).to be true
      expect(@game.player_can_move?('black')).to be true
      expect(@game.piece_at(4, 3).move_to!(8, 7)).to be true
      expect(@game.player_can_move?('white')).to be true
      expect(@game.piece_at(2, 8).move_to!(3, 8)).to be true
      expect(@game.player_can_move?('black')).to be true
      expect(@game.piece_at(6, 7).move_to!(7, 6)).to be true
      expect(@game.player_can_move?('white')).to be true
      expect(@game.piece_at(3, 8).move_to!(5, 6)).to be true
      expect(@game.player_can_move?('black')).to be false
    end
  end
end
