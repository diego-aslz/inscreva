class FieldFill < ActiveRecord::Base
  belongs_to :event_field
  belongs_to :subscription
  attr_accessible :value, :event_field_id, :subscription_id
end
