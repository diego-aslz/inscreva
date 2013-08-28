
module Concerns
  module DateFieldFill
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
          strftime('%Y-%m-%d') rescue '' end
    end
  end
end
