class AddGameResultToGames < ActiveRecord::Migration
  def change
    add_column :games, :game_result, :string, default: nil
    add_column :games, :game_over_reason, :string, default: nil
  end
end
