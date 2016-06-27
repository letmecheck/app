class AddLastRequestAtToUsers < ActiveRecord::Migration
  def change
    remove_column :users, :last_request_at, :datetime
  end
end
