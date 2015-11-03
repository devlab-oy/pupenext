require 'test_helper'

class TimeOfDayTest < ActiveSupport::TestCase
  test 'initialization with wrong values' do
    assert_raise ArgumentError do
      TimeOfDay.new(nil)
    end

    assert_raise ArgumentError do
      TimeOfDay.new('')
    end
  end

  test 'should return valid time' do
    assert_equal '12:00:00', TimeOfDay.new(time: '12:00:00').to_s
    assert_equal '12:00:00', TimeOfDay.new(time: DateTime.new(2007,11,19,12,00,00,"-06:00")).to_s
    assert_equal '12:00:00', TimeOfDay.new(time: Time.parse("12:00")).to_s
  end
end
