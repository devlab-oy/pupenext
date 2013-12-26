ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'simplecov'

if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    CodeClimate::TestReporter::Formatter
  ]
else
  SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
end

SimpleCov.start 'rails'

Turn.config do |t|
  t.format = :outline
  t.natural = true
end

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  fixtures :all
end
