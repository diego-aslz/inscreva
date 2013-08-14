class Role < ActiveRecord::Base
  has_many :delegations
  has_and_belongs_to_many :permissions
  validates_presence_of :name
  attr_accessible :name
end
