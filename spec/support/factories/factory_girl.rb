FactoryGirl.define do
  sequence(:email) { |n| "email#{n}@example.com" }

  factory :admin_user do
    email
    password 'password'
    password_confirmation 'password'

    factory :superadmin do
      after(:create) do |user,evaluator|
        user.roles << create(:role)
      end
    end
  end

  factory :user do
    email
    password 'password'
    password_confirmation 'password'

    factory :candidate_user do
      after(:create) do |user,evaluator|
        user.subscriptions << create(:subscription)
      end
    end
  end

  factory :role do
    name 'superadmin'
  end

  factory :event do
    name 'Contest sample'
    email
    technical_email 'systems@nomail.com'
    allow_edit true
    opens_at { Time.zone.now }
    closes_at { Time.zone.now + 1.day }
    rules_url ''

    factory :ongoing_event do
      opens_at { Time.zone.now - 30.minutes }
      closes_at { Time.zone.now + 30.minutes }
    end

    factory :past_event do
      opens_at { Time.zone.now - 1.hour }
      closes_at { Time.zone.now - 30.minutes }
    end

    factory :future_event do
      opens_at { Time.zone.now + 30.minutes }
      closes_at { Time.zone.now + 1.hour }
    end
  end

  factory :subscription do
    association :event, factory: :ongoing_event
    email
    id_card '1234567890'
    name 'Jorge'
  end

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

  factory :event_field do
    association :event, factory: :ongoing_event
    sequence(:name) { |n| "field#{n}" }
    field_type 'boolean'
  end

  factory :field_fill do
    event_field
    value true
    subscription
  end
end
