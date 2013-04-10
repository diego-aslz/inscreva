class User < ActiveRecord::Base
  is_activable
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name
  # attr_accessible :title, :body

  has_many :permissions
  has_many :roles, through: :permissions

  scope :search, ->(s) {
    where(%(
      lower(email) like lower(?)
    ), "%#{s}%")
  }

  def has_role?(role_name)
    roles.each { |r| return true if r.name == role_name.to_s }
    false
  end
end
