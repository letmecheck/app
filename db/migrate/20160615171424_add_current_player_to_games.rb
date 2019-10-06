class AddCurrentPlayerToGames < ActiveRecord::Migration[4.2]
  def change
    add_column :games, :current_player, :integer, default: 0, null: false
  end
end
