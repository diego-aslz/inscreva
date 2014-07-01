
module Concerns
  module CountryFieldFill
    def country_value_to_s
      value && I18n.t("countries.#{value}") || ''
    end
  end
end
