require 'test_helper'

class WeekTest < ActiveSupport::TestCase
  test 'initialize' do
    assert Week.new('2017-01-01')
    assert Week.new('2017-01-01'.to_date)

    assert_raises { Week.new }
    assert_raises { Week.new 'foo' }
    assert_raises { Week.new nil }
    assert_raises { Week.new '2017-01-32' }
  end

  test 'human' do
    assert_equal '52 / 2016', Week.new('2017-01-01').human
    assert_equal '01 / 2017', Week.new('2017-01-05').human
    assert_equal '10 / 2017', Week.new('2017-03-12').human
  end

  test 'compact' do
    assert_equal '201652', Week.new('2017-01-01').compact
    assert_equal '201701', Week.new('2017-01-05').compact
    assert_equal '201710', Week.new('2017-03-12').compact
  end
end
