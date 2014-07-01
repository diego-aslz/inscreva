class FieldFill < ActiveRecord::Base
  include Concerns::CheckBoxesFieldFill
  include Concerns::DateFieldFill
  include Concerns::FileFieldFill
  include Concerns::CountryFieldFill
  include Concerns::BooleanFieldFill
  include Concerns::SelectFieldFill
  include Concerns::TextFieldFill

  belongs_to :field
  belongs_to :subscription

  validates_presence_of :value, if: :require_value?
  validates :value, numericality: true, if: :validate_numeric?

  def validate_numeric?
    field.is_numeric? && !value.blank?
  end

  def value_to_s
    method = "#{field.field_type}_value_to_s"
    return send(method) if respond_to? method
    value
  end

  private

  def require_value?
    field.required && !field.file? && !field.text?
  end
end
