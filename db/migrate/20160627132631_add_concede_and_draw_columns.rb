class AddConcedeAndDrawColumns < ActiveRecord::Migration
  def change
    add_column :games, :white_player_draw, :boolean, default: false
    add_column :games, :black_player_draw, :boolean, default: false
    add_column :games, :game_conceding_player, :string
  end
end
