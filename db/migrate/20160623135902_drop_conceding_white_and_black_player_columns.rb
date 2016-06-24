class DropConcedingWhiteAndBlackPlayerColumns < ActiveRecord::Migration
  def change
    remove_column :games, :white_player_concede
    remove_column :games, :black_player_concede
  end
end
