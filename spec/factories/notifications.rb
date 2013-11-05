FactoryGirl.define do
  factory :notification do
    subject "Some Subject"
    event
    message 'Hi'
    respond 'atest@domain.com'
    recipients ['a@bc.com']
  end
end
