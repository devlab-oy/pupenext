require 'codeclimate-test-reporter'
ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'login_helper'
require 'spreadsheets_helper'

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

  fixtures %w(
    companies
    dictionaries
    keywords
    parameters
    permissions
    users
  )

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

  def json_response
    ActiveSupport::JSON.decode @response.body
  end
end

# Patch fixtures for now, so STI tables are not deleted. This is fixed in rails master (5?).
# from activerecord-4.2.4/lib/active_record/fixtures.rb
module ActiveRecord
  class FixtureSet
    def self.create_fixtures(fixtures_directory, fixture_set_names, class_names = {}, config = ActiveRecord::Base)
      fixture_set_names = Array(fixture_set_names).map(&:to_s)
      class_names = ClassCache.new class_names, config

      # FIXME: Apparently JK uses this.
      connection = block_given? ? yield : ActiveRecord::Base.connection

      files_to_read = fixture_set_names.reject { |fs_name|
        fixture_is_cached?(connection, fs_name)
      }

      unless files_to_read.empty?
        connection.disable_referential_integrity do
          fixtures_map = {}

          fixture_sets = files_to_read.map do |fs_name|
            klass = class_names[fs_name]
            conn = klass ? klass.connection : connection
            fixtures_map[fs_name] = new( # ActiveRecord::FixtureSet.new
              conn,
              fs_name,
              klass,
              ::File.join(fixtures_directory, fs_name))
          end

          update_all_loaded_fixtures fixtures_map

          connection.transaction(:requires_new => true) do
            deleted_tables = []
            fixture_sets.each do |fs|
              conn = fs.model_class.respond_to?(:connection) ? fs.model_class.connection : connection
              table_rows = fs.table_rows

              table_rows.each_key do |table|
                unless deleted_tables.include? table
                  conn.delete "DELETE FROM #{conn.quote_table_name(table)}", 'Fixture Delete'
                end
                deleted_tables << table
              end

              table_rows.each do |fixture_set_name, rows|
                rows.each do |row|
                  conn.insert_fixture(row, fixture_set_name)
                end
              end

              # Cap primary key sequences to max(pk).
              if conn.respond_to?(:reset_pk_sequence!)
                conn.reset_pk_sequence!(fs.table_name)
              end
            end
          end

          cache_fixtures(connection, fixtures_map)
        end
      end
      cached_fixtures(connection, fixture_set_names)
    end
  end
end
