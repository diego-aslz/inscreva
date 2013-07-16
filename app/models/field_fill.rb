class FieldFill < ActiveRecord::Base
  belongs_to :event_field
  belongs_to :subscription

  mount_uploader :file, FileFieldUploader

  attr_accessible :value, :event_field_id, :subscription_id, :type, :file,
      :remove_file, :file_cache, :value_cb
  validates_presence_of :value, if: :require_value?
  validates_presence_of :file, if: :require_file?

  def value_cb
    value.split ',' if value
  end

  def value_cb=(value_cb)
    self.value = value_cb.reject{|v| v.blank? }.join ','
  end

  private

  def require_value?
    event_field.required && !event_field.file?
  end

  def require_file?
    event_field.required && event_field.file?
  end
end
