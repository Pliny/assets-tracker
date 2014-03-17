FactoryGirl.define do
  factory :user do
    first_name 'dude'
    sequence(:email) { |n| "dude#{n}@example.com" }
  end
end

FactoryGirl.define do
  factory :asset do
    serial_no 'DEVZASER'
    ignore do
      user_args nil
    end
    user { create(:user, user_args) }
  end
end
