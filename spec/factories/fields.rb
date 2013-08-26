FactoryGirl.define do
  factory :field do
    association :event, factory: :ongoing_event
    sequence(:name) { |n| "field#{n}" }
    field_type 'string'

    factory :select_field do
      field_type 'select'
    end

    factory :required_field do
      required true
    end
  end
end
