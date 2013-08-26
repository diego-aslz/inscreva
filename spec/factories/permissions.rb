FactoryGirl.define do
  factory :permission do
    sequence :action, 'index0'
    subject_class 'Event'
  end
end
