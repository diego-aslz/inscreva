
module Concerns
  module DateFieldFill
    extend ActiveSupport::Concern

    included do
      validates_presence_of :value_date, if: :require_date?
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

    def value_date=(value_date)
      self.value = begin Time.strptime(value_date, '%d/%m/%Y').
          strftime('%Y-%m-%d') rescue nil end
    end

    def require_date?
      require_value? && field.date?
    end

    def self.to_date(str)
      begin Date.strptime(str, '%d/%m/%Y').strftime('%Y-%m-%d') rescue nil end
    end
  end
end
