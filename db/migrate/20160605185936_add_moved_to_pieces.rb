class AddMovedToPieces < ActiveRecord::Migration[4.2]
  def change
    add_column :pieces, :moved, :boolean, default: false
  end
end
