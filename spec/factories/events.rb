FactoryGirl.define do
  factory :event do
    name 'Contest sample'
    email
    technical_email 'systems@nomail.com'
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
end
