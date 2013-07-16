class FieldFill < ActiveRecord::Base
  belongs_to :event_field
  belongs_to :subscription

  mount_uploader :file, FileFieldUploader

  attr_accessible :value, :event_field_id, :subscription_id, :type, :file,
      :remove_file, :file_cache
end
