class AddEnPassantFileToGames < ActiveRecord::Migration
  def change
    add_column :games, :en_passant_file, :integer
  end
end
