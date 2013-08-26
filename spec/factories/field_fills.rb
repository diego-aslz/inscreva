FactoryGirl.define do
  factory :field_fill do
    field
    value true
    subscription

    factory :required_field_fill do
      association :field, factory: :required_field
    end
  end
end
