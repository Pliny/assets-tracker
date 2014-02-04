# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end

ENV['EMAIL_SERVER'] = 'example.com'

Capybara.configure do |config|
  config.javascript_driver = :webkit
end

OmniAuth.config.test_mode = true

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.ignore_localhost = true
end

def login(user = FactoryGirl.create(:user))
  controller.sign_in(user)
  user
end

def setup_google_omniauth
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
    {
      'uid'  => '12345',
      'info' => {
        'first_name' => 'Fixture First Name',
        'last_name'  => 'Fixture Last Name',
        'email'      => 'dude@example.com',
        'image'      => 'https://fixture/google/profile/image/url.gif'
      },
      'extra' => {
        'raw_info' => {
          'hd' => 'example.com'
        }
      },
      'credentials' => {
        'token' => 'VALID_TOKEN'
      }
    }
  )
end

def integration_login
  setup_google_omniauth
  visit '/auth/google_oauth2'
end

