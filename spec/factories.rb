FactoryGirl.define do
  factory :user do
    first_name 'dude'
    sequence(:email) { |n| "dude#{n}@example.com" }
  end
end
