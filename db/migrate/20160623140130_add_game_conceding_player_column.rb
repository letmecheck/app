class AddGameConcedingPlayerColumn < ActiveRecord::Migration
  def change
    add_column :games, :game_conceding_player, :string
  end
end
