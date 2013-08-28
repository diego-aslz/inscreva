
module Concerns
  module CheckBoxesFieldFill
    def value_cb
      value.split ',' if value
    end

    def value_cb=(value_cb)
      self.value = value_cb.reject{|v| v.blank? }.join ','
    end

    def check_boxes_value_to_s
      value_cb.map { |v| field.select_value(v) }.join ', '
    end
  end
end
