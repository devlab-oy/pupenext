source 'https://rubygems.org'

gem 'rails', '~> 4.2'

gem 'bcrypt'
gem 'jquery-rails'
gem 'mysql2'
gem 'turbolinks'
gem 'dotenv-rails'

gem 'resque'
gem 'resque-web', require: 'resque_web'

gem 'date_validator'
gem 'request_store'

group :assets do
  gem 'uglifier'
end

platforms :ruby do
  gem 'therubyracer'
end

group :production do
  gem 'dalli'
end

group :test, :development do
  gem 'rake'
  gem 'minitest'
  gem 'codeclimate-test-reporter'
  gem 'i18n-tasks'
end
