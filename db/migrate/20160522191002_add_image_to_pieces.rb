class AddImageToPieces < ActiveRecord::Migration
  def change
    add_column :pieces, :img, :string
  end
end
