class FieldFill < ActiveRecord::Base
  belongs_to :field
  belongs_to :subscription

  mount_uploader :file, FileFieldUploader

  attr_accessible :value, :field_id, :subscription_id, :type, :file,
      :remove_file, :file_cache, :value_cb, :value_date
  validates_presence_of :value, if: :require_value?
  validates_presence_of :file, if: :require_file?

  after_save :clean_remove_file

  def value_cb
    value.split ',' if value
  end

  def value_cb=(value_cb)
    self.value = value_cb.reject{|v| v.blank? }.join ','
  end

  def value_as_date
    Date.strptime(value, '%Y-%m-%d')
  end

  def value_date
    begin
      value_as_date.strftime '%d/%m/%Y'
    rescue
      ''
    end
  end

  def changed?
    !!(super or remove_file)
  end

  def clean_remove_file
    self.remove_file = nil
  end

  def value_date=(value_date)
    self.value = Time.strptime(value_date, '%d/%m/%Y').strftime('%Y-%m-%d')
  end

  private

  def require_value?
    field.required && !field.file?
  end

  def require_file?
    field.required && field.file?
  end
end
