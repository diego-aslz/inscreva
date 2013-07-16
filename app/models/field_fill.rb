class FieldFill < ActiveRecord::Base
  belongs_to :event_field
  belongs_to :subscription

  has_attached_file :file

  attr_accessible :value, :event_field_id, :subscription_id, :type, :file
end
