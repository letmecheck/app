class AddEnPassantFileToGames < ActiveRecord::Migration[4.2]
  def change
    add_column :games, :en_passant_file, :integer
  end
end
