class Permission < ActiveRecord::Base
  validates_presence_of :action, :subject_class
  validates_uniqueness_of :action, scope: :subject_class
  has_and_belongs_to_many :roles
end
