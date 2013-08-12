FactoryGirl.define do
  sequence(:email) { |n| "email#{n}@example.com" }

  factory :user do
    email
    password 'password'
    password_confirmation 'password'

    factory :admin_user do
      email
      password 'password'
      password_confirmation 'password'
    end

    factory :admin do
      admin true
    end

    factory :candidate_user do
      after(:create) do |user,evaluator|
        user.subscriptions << create(:subscription)
      end
    end
  end

  factory :permission do
    sequence :action, 'index0'
    subject_class 'Event'
  end

  factory :role do
    name 'Test'
  end

  factory :delegation do
    role
    user
    event
  end

  factory :event do
    name 'Contest sample'
    email
    technical_email 'systems@nomail.com'
    allow_edit true
    opens_at { Time.zone.now }
    closes_at { Time.zone.now + 1.day }
    rules_url ''
    sequence :identifier, 'event1'

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

  factory :field_fill do
    field
    value true
    subscription

    factory :required_field_fill do
      association :field, factory: :required_field
    end
  end

  factory :page do
    sequence :name, 'page1'
    event
    title 'Title'
  end
end
