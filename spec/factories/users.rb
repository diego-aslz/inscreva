FactoryGirl.define do
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

    factory :subscriber_user do
      after(:create) do |user,evaluator|
        user.subscriptions << create(:subscription)
      end
    end
  end
end
