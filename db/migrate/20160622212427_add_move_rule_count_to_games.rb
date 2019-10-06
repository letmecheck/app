class AddMoveRuleCountToGames < ActiveRecord::Migration[4.2]
  def change
    add_column :games, :move_rule_count, :integer, default: 0
  end
end
