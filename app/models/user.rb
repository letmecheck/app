class User < ActiveRecord::Base
  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


         def self.find_for_database_authentication(warden_conditions)
               conditions = warden_conditions.dup
               if login = conditions.delete(:login)
                 where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
               elsif conditions.has_key?(:username) || conditions.has_key?(:email)
                 where(conditions.to_hash).first
               end
             end


  has_many :games
end
