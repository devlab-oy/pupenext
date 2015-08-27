require 'codeclimate-test-reporter'
ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'login_helper'

if ENV['CODECLIMATE_REPO_TOKEN']
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    CodeClimate::TestReporter::Formatter
  ]
else
  SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
  SimpleCov.add_group 'Validators', '/app/validators/'
  SimpleCov.add_group 'Modules', '/app/modules/'
end

SimpleCov.start 'rails'

def assets_file(name)
  File.read(Rails.root.join('test', 'assets', name)).chomp
end

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  self.use_transactional_fixtures = false

  fixtures %w(users companies permissions dictionaries keywords parameters)

  setup do
    RequestStore.clear!
    Current.company = companies(:acme)
  end

  teardown do
    RequestStore.clear!
    Current.company = nil
  end
end

# Add login/logout method for controller tests
class ActionController::TestCase
  include LoginHelper

  setup do
    RequestStore.clear!
    Current.company = companies(:acme)
  end

  teardown do
    RequestStore.clear!
    Current.company = nil
  end
end

