FactoryGirl.define do
  factory :page do
    sequence :name, 'page1'
    event
    title 'Title'
  end
end
