class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable,
      :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :admin

  has_many :subscriptions
  has_many :delegations

  scope :search, ->(term) {
    where('concat(COALESCE(name,\'\'),email) like ?', "%#{term}%")
  }
end
