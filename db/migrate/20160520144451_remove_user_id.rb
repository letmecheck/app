class RemoveUserId < ActiveRecord::Migration[4.2]
  def change
    remove_column :games, :user_id, :integer
  end
end
