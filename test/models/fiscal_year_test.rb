require 'test_helper'

class FiscalYearTest < ActiveSupport::TestCase
  setup do
    @one = fiscal_years(:one)
    @two = fiscal_years(:two)
    @user = users(:bob)
    @company = companies(:acme)
  end

  test 'fixtures are valid' do
    assert @one.valid?
    assert @two.valid?
  end

  test 'relations' do
    assert_not_nil @one.company
  end

  test 'should have begin and end date' do
    fiscal_year = FiscalYear.new
    fiscal_year.tilikausi_alku = Date.today
    fiscal_year.laatija = @user
    fiscal_year.muuttaja = @user
    fiscal_year.company = @company

    refute fiscal_year.valid?

    fiscal_year.tilikausi_loppu = Date.today + 1

    assert fiscal_year.valid?
  end

  test 'start should be before end' do
    fiscal_year = FiscalYear.new
    fiscal_year.tilikausi_alku = Date.today
    fiscal_year.laatija = @user
    fiscal_year.muuttaja = @user
    fiscal_year.company = @company

    refute fiscal_year.valid?

    fiscal_year.tilikausi_loppu = Date.today - 1

    refute fiscal_year.valid?

    fiscal_year.tilikausi_loppu = Date.today + 1

    assert fiscal_year.valid?
  end
end
