class EventField < ActiveRecord::Base
  belongs_to :event
  attr_accessible :field_type, :name, :required
  validates_presence_of :field_type, :name
end
