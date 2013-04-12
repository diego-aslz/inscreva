FactoryGirl.define do
  factory :user do
    email 'admin@example.com'
    password 'test1234'
    password_confirmation 'test1234'
  end

  factory :role do
    name 'admin'
  end

  factory :contest do
    allow_edit true
    begin_at Time.zone.now - 1.week
    email 'contest@nomail.com'
    end_at Time.zone.now + 1.week
    name 'Contest sample'
    rules_url ''
    technical_email 'systems@nomail.com'
  end
end
