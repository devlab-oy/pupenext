source 'https://rubygems.org'

gem 'rails', '~> 4.1.6'

gem 'bcrypt-ruby'
gem 'jquery-rails'
gem 'mysql2'
gem 'turbolinks'
gem 'dotenv-rails'

gem 'resque'
gem 'resque-web', require: 'resque_web'

group :production do
  gem 'therubyracer', '~> 0.11.4'
  gem 'dalli'
end

group :assets do
  gem 'uglifier'
end

group :test do
  gem 'rake'
  gem 'minitest'
  gem "codeclimate-test-reporter"
end

group :development, :test do
  gem 'sqlite3'
end
