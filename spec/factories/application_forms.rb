FactoryGirl.define do
  factory :application_form do
    association :event, factory: :ongoing_event
    email
    email_confirmation { email }
    id_card '1234567890'
    name 'Jorge'
    password 'JorgeJorge'
    password_confirmation 'JorgeJorge'
    confirmed 'true'
  end
end
