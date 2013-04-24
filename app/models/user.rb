class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  has_many :permissions, as: :user
  has_many :roles, through: :permissions
  has_many :subscriptions

  def has_role?(role)
    roles.each { |r| return true if r.name == role.name.to_s }
    false
  end
end
