class AddCurrentPlayerToGames < ActiveRecord::Migration
  def change
    add_column :games, :current_player, :integer, default: 0, null: false
  end
end
