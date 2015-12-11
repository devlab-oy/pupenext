require 'test_helper'

class DepreciationDifferenceReportTest < ActiveSupport::TestCase
  fixtures %w(
    fixed_assets/commodities
    fixed_assets/commodity_rows
    accounts
    heads
    head/voucher_rows
    fiscal_years
    sum_levels
  )

  setup do
    @company = companies :acme
  end

  test 'report initialize and data' do
    report = DepreciationDifferenceReport.new(@company)

    example_data = {
      "4444" => {
        :nimi => "EVL poistoerovastatili",
        :lisaykset => 10000.0,
        :evl_poistot => -1001.0,
        :sumu_poistot => -0.0,
        :poistoero => 1001.0,
        :menojaannos => 10000.0,
        :kum_poistoero => -111.0
      },
      "4443" => {
        :nimi=>"Kiinteistöhankintatili",
        :lisaykset => 0.0,
        :evl_poistot => 0,
        :sumu_poistot => 0,
        :poistoero => 0,
        :menojaannos => 0,
        :kum_poistoero => 0
      }
    }

    assert_equal example_data, report.data
  end
end
