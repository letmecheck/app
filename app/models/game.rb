class Game < ActiveRecord::Base
  belongs_to :user
  has_one :black_player, through: :enrollment, source: :user
  has_one :enrollment
end
