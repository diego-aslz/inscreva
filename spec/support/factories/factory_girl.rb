FactoryGirl.define do
  factory :user do
    email 'admin@example.com'
    password 'test1234'
    password_confirmation 'test1234'
  end

  factory :role do
    name 'admin'
  end
end
