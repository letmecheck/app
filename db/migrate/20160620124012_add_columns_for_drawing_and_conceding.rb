class AddColumnsForDrawingAndConceding < ActiveRecord::Migration
  def change
    add_column :games, :white_player_draw, :boolean, default: false
    add_column :games, :black_player_draw, :boolean, default: false
    add_column :games, :white_player_concede, :boolean, default: false
    add_column :games, :black_player_concede, :boolean, default: false 
  end
end
