source 'https://rubygems.org'

ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.1'
gem 'pg'

gem 'json'

gem "roo", "~> 1.13.2"

gem "paper_trail", "~> 3.0.1"

gem 'kaminari', '~> 0.15.1'
gem 'bootstrap-kaminari-views'

# Gems used only for assets and not required
# in production environments by default.
gem 'bootstrap-sass', '~> 3.0.2.1'
group :assets, :development, :test do
  gem 'sass-rails',   '~> 4.0.0'
  gem 'coffee-rails', '~> 4.0.1'
  gem 'sprockets-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.3.0'
  gem 'yui-compressor'
end
gem 'asset_sync'
gem 'unf'

group :development, :test do
  gem 'capybara'
  gem 'listen'
  gem 'spring'
  gem 'spring-commands-rspec'
end

gem 'rails_12factor', group: :production

group :test do
  gem 'vcr'
  gem 'webmock', "~>1.15.2"
  gem 'timecop'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'capybara-webkit'
end

gem 'jquery-rails'
gem 'rspec-rails'
gem 'haml'
gem "omniauth-google-oauth2", "~> 0.2.2"

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
