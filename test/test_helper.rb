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

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  fixtures :all
  self.use_transactional_fixtures = false

  setup do
    RequestStore.clear!
    Company.current = companies(:acme)
  end

  teardown do
    RequestStore.clear!
    Company.current = nil
  end
end

# Add login/logout method for controller tests
class ActionController::TestCase
  include LoginHelper

  setup do
    RequestStore.clear!
    Company.current = companies(:acme)
  end

  teardown do
    RequestStore.clear!
    Company.current = nil
  end
end

