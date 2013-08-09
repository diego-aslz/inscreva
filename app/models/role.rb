class Role < ActiveRecord::Base
  validates_presence_of :action, :subject_class
  validates_uniqueness_of :action, scope: :subject_class
end
