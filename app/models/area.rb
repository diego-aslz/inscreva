class Area < ActiveRecord::Base
  belongs_to :event
  attr_accessible :name, :requirement, :special_vacation, :vacation, :event_id
  validates_presence_of :name, :special_vacation, :vacation
end
