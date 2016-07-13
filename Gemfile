source 'https://rubygems.org'
ruby '>= 2.2.2'

gem 'rails', '~> 4.2'

gem 'bcrypt'
gem 'jquery-rails'
gem 'coffee-rails'
gem 'mysql2', '~> 0.3.18'
gem 'turbolinks'
gem 'dotenv-rails'

gem 'resque'
gem 'redis-namespace'
gem 'resque-web', require: 'resque_web'

gem 'date_validator'
gem 'request_store'
gem 'cocoon'
gem 'simple_form'
gem 'country_select'
gem 'roo'
gem 'axlsx'
gem 'axlsx_rails'
gem 'pdfkit'
gem 'lightbox2-rails'
gem 'wicked_pdf'
gem 'whenever', require: false

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
  gem 'localeapp'
end

group :test do
  gem 'fakeredis'
  gem 'mocha'
end
