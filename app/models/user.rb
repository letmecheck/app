class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  after_create :initialize_wins_and_losses
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :games
  
  private
  
  def initialize_wins_and_losses
    update_attribute(:wins, 0)
    update_attribute(:losses, 0)
  end
end
