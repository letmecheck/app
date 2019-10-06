class ReallyAddLastRequestAtToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :last_request_at, :datetime
  end
end
