require 'test_helper'

# Create dummy class for testing Searchable conceren using yhtio -table
class DummyClass < ActiveRecord::Base
  include Searchable
  self.table_name = :yhtio
end

class SearchableTest < ActiveSupport::TestCase
  test 'test where_like search' do
    assert_equal 1, DummyClass.where_like(:yhtio, 'acme').count
    assert_equal 2, DummyClass.where_like(:nimi, 'orporati').count
    assert_equal 1, DummyClass.where_like('maa', 'EE').count
    assert_equal 0, DummyClass.where_like('yhtio', 'not_found').count
  end

  test 'test search_like search parameters' do
    assert_raises(ArgumentError) { DummyClass.search_like("string") }
    assert_nothing_raised { DummyClass.search_like( {} ) }
  end

  test 'test search_like exact search' do
    assert_equal 1, DummyClass.search_like(nimi: 'Estonian').count, 'like match should return 1'
    assert_equal 0, DummyClass.search_like(nimi: '@estonian').count, '@ char should do exact match'
    assert_equal 1, DummyClass.search_like(nimi: '@estonian corporation').count

    args = {
      nimi: '@estonian corporation',
      yhtio: 'esto'
    }

    assert_equal 1, DummyClass.search_like(args).count, "multiple hashes do AND query"
  end
end
