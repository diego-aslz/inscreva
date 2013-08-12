class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable,
      :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :admin

  has_many :roles, as: :user
  has_many :permissions, through: :roles
  has_many :subscriptions
end
