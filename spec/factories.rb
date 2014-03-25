FactoryGirl.define do
  factory :user do
    first_name 'dude'
    last_name  'dodgington'
    sequence(:email) { |n| "dude#{n}@example.com" }
  end
end

FactoryGirl.define do
  factory :asset do
    sequence(:serial_no) { |n| "DEVZASER#{n}"}
    ignore do
      user_args nil
      hardware_version_args nil
    end
    user { create(:user, user_args) }
    hardware_version { create(:hardware_version, hardware_version_args) }
  end
end

FactoryGirl.define do
  factory :hardware_version do
    sequence(:name) { |n| "spinname#{n}" }
    project 'tiburon'
  end
end
