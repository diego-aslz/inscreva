class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable,
      :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :admin

  has_many :subscriptions, dependent: :destroy
  has_many :delegations, dependent: :destroy

  scope :search, ->(term) {
    where('concat(COALESCE(name,\'\'),email) like ?', "%#{term}%")
  }
  scope :not_subscribers, -> {
    where('users.id in (select distinct user_id from delegations) or ' +
        'users.id not in (select distinct user_id from subscriptions)')
  }
end
