class FieldFill < ActiveRecord::Base
  include Concerns::CheckBoxesFieldFill
  include Concerns::DateFieldFill
  include Concerns::FileFieldFill
  include Concerns::CountryFieldFill
  include Concerns::BooleanFieldFill
  include Concerns::SelectFieldFill

  belongs_to :field
  belongs_to :subscription

  attr_accessible :value, :field_id, :subscription_id, :type, :file,
      :remove_file, :file_cache, :value_cb, :value_date
  validates_presence_of :value, if: :require_value?
  validates :value, numericality: true, if: :validate_numeric?

  def validate_numeric?
    field.is_numeric? && !value.blank?
  end

  def value_to_s
    return '' if value.blank?
    method = "#{field.field_type}_value_to_s"
    return send(method) if respond_to? method
    value
  end

  private

  def require_value?
    field.required && !field.file?
  end
end
