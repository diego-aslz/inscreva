FactoryGirl.define do
  factory :subscription do
    association :event, factory: :ongoing_event
    email
    id_card '1234567890'
    name 'Jorge'
  end
end
