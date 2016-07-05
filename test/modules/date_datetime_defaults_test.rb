require 'test_helper'

class DateDatetimeDefaultsTest < ActiveSupport::TestCase
  fixtures %w(
    heads
  )

  test 'date fields are set to zero by default correctly' do
    head = Head.create!(tila: 'N')

    assert_equal 0,                    head.erpcm
    assert_equal '2016-01-02'.to_date, heads(:si_one).erpcm
  end

  test 'datetime fields are set to zero by default correctly' do
    head = Head.create!(tila: 'N')

    assert_equal '0000-00-00 00:00:00',                  head.h1time
    assert_equal Time.zone.local(2016, 1, 2, 12, 0, 12), heads(:si_one).h1time
  end
end
