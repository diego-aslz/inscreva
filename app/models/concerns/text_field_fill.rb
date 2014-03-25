module Concerns
  module TextFieldFill
    extend ActiveSupport::Concern

    included do
      validates_presence_of :value_text, if: :require_text?
    end

    private

    def require_text?
      field.required && field.text?
    end
  end
end
