class AddImageToPieces < ActiveRecord::Migration[4.2]
  def change
    add_column :pieces, :img, :string
  end
end
