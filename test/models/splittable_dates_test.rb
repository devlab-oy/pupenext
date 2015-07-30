require 'test_helper'

# Create dummy class for testing SplittableDates concern using yhtio -table
class DummyClass < ActiveRecord::Base
  include SplittableDates

  self.table_name = :yhtio

  splittable_dates :tilikausi_alku
  validates :tilikausi_alku, date: true
end

class SplittableDatesTest < ActiveSupport::TestCase
  setup do
    @dummy = DummyClass.first
  end

  test "should be able to set date as string" do
    @dummy.tilikausi_alku = '2014-02-31'
    refute @dummy.valid?

    @dummy.tilikausi_alku = '2014-01-01'
    assert @dummy.valid?
  end

  test "should be able to set date as a hash" do
    @dummy.tilikausi_alku = { day: 31, month: 2, year: 2014 }
    refute @dummy.valid?

    @dummy.tilikausi_alku = { day: 1, month: 1, year: 2014 }
    assert @dummy.valid?
    assert_equal '2014-01-01', @dummy.tilikausi_alku.to_s

    @dummy.tilikausi_alku = { "day" => 10, "month" => 10, "year" => 2015 }
    assert @dummy.valid?
    assert_equal '2015-10-10', @dummy.tilikausi_alku.to_s
  end

  test "should fail hash unless all keys are found" do
    @dummy.tilikausi_alku = { month: 1, year: 2014 }
    refute @dummy.valid?

    @dummy.tilikausi_alku = { day: 1, year: 2014 }
    refute @dummy.valid?

    @dummy.tilikausi_alku = { day: 1, month: 1 }
    refute @dummy.valid?
  end
end
