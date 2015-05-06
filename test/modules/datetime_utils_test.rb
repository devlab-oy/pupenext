require 'test_helper'

class DatetimeUtilsTest < ActiveSupport::TestCase
  test 'is db date' do
    refute DatetimeUtils.is_db_date?('2003')
    refute DatetimeUtils.is_db_date?('2003-02')
    refute DatetimeUtils.is_db_date?('2003-02-42')

    assert DatetimeUtils.is_db_date?('2003-02-01')
    assert DatetimeUtils.is_db_date?('2003-2-1')

    refute DatetimeUtils.is_db_date?('1.1.2003')
  end

  test 'is db format' do
    assert DatetimeUtils.is_db_date?('2003-02-01')
    refute DatetimeUtils.is_db_date?('1.1.2003')

    refute DatetimeUtils.is_db_date?('2003-31-12')
    assert DatetimeUtils.is_db_date?('2003-12-31')
  end

  test 'is valid' do
    assert DatetimeUtils.is_valid?('2003-02-01')
    refute DatetimeUtils.is_valid?('2003-02-42')

    assert DatetimeUtils.is_valid?('01.02.2003')
    assert DatetimeUtils.is_valid?('02/01/2003')
  end
end
