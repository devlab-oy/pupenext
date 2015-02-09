require 'test_helper'

class FiscalYearTest < ActiveSupport::TestCase
  setup do
    @one = fiscal_years(:one)
    @two = fiscal_years(:two)
  end

  test 'fixtures are valid' do
    assert @one.valid?
    assert @two.valid?
  end

  test 'relations' do
    assert_not_nil @one.company
  end
end
