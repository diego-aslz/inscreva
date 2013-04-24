FactoryGirl.define do
  factory :admin_user do
    sequence(:email) { |n| "admin#{n}@example.com" }
    password 'password'
    password_confirmation 'password'
  end

  factory :user do
    sequence(:email) { |n| "candidate#{n}@example.com" }
    password 'password'
    password_confirmation 'password'
  end

  factory :role do
    name 'superadmin'

    factory :candidate_role do
      name 'candidate'
    end
  end

  factory :event do
    name 'Contest sample'
    email 'contest@nomail.com'
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
    user
    email { user.email }
    id_card '1234567890'
  end
end
