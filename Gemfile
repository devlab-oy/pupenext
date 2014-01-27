source 'https://rubygems.org'
ruby '2.1.0'

gem 'rails', '4.0.2'

gem 'bcrypt-ruby'
gem 'jquery-rails'
gem 'mysql2'
gem 'turbolinks'
gem 'dotenv-rails'

group :production do
  gem 'therubyracer'
  gem 'dalli'
end

group :assets do
  gem 'uglifier'
end

group :test do
  gem 'rake'
  gem 'minitest'
  gem 'turn'
  gem "codeclimate-test-reporter"
end

group :development, :test do
  gem 'sqlite3'
end
