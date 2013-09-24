class Delegation < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  belongs_to :role
  has_many :permissions, through: :role

  attr_accessible :user_id, :user_name, :event_id, :role_id
  validates_presence_of :user_id, :role_id

  def user_name
    user.name if user
  end

  def user_name=(user_name)
  end
end
