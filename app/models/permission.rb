class Permission < ActiveRecord::Base
  belongs_to :user, polymorphic: true
  belongs_to :role
  belongs_to :event

  attr_accessible :role_id, :user_id
end
