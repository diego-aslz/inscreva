
module Concerns
  module BooleanFieldFill
    def boolean_value_to_s
      if value.to_s == 'true'
        I18n.t('yes')
      elsif value.to_s == 'false'
        I18n.t('no')
      else
        ''
      end
    end
  end
end
