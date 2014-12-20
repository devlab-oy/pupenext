source 'https://rubygems.org'

gem 'rails', '~> 4.2'

gem 'bcrypt-ruby'
gem 'jquery-rails'
gem 'mysql2'
gem 'turbolinks'
gem 'dotenv-rails'

gem 'resque'
gem 'resque-web', require: 'resque_web'

group :assets do
  gem 'uglifier'
end

group :production do
  gem 'therubyracer'
  gem 'dalli'
end

group :test, :development do
  gem 'rake'
  gem 'minitest'
  gem "codeclimate-test-reporter"
end
