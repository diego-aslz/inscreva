class Role < ActiveRecord::Base
  has_many :delegations, dependent: :destroy
  has_and_belongs_to_many :permissions, order: :subject_class
  validates_presence_of :name
  attr_accessible :name, :permission_ids
end
