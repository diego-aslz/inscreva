class Delegation < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  belongs_to :role
  has_many :permissions, through: :role

  attr_accessible :user_id, :event_id, :role_id
  validates_presence_of :user_id, :event_id, :role_id
end
