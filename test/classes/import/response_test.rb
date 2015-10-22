require 'test_helper'

class Import::ResponseTest < ActiveSupport::TestCase
  setup do
    @response = Import::Response.new
    @columns = ['foo', 'bar', 'baz']
    @headers = ['name', 'address', 'zip']
  end

  test 'should add rows with columns and numbers' do
    @response.add_row columns: @columns
    assert_equal @columns, @response.rows.first.columns
    assert_equal 1, @response.rows.first.number
    assert_equal 'foo', @response.rows.first.columns.first

    @response.add_row columns: @columns, errors: ['bad']
    assert_equal 2, @response.rows.count
    assert_equal 2, @response.rows.last.number
    assert_equal 'bad', @response.rows.last.errors.first
  end

  test 'should add headers' do
    @response.add_headers names: @headers
    assert_equal @headers, @response.headers
    assert_equal 'name', @response.headers.first
  end
end
