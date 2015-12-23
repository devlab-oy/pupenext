require 'test_helper'

class DepreciationsBalanceSheetReportTest < ActiveSupport::TestCase
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
    report = DepreciationsBalanceSheetReport.new(@company)

    example_data = {
      "4444" => {
        :nimi => "EVL poistoerovastatili",
        :poistoaika => 0,
        :hankinnat_yht => 10000.0,
        :tilikauden_poistot_yht => 0.0,
        :menojaannos_yht => 0,
        :tilikaudet => {
          "9801909624444" => {
            :tilikausi => "1.1.2014 - 31.12.2014",
            :hankinnat => 0.0,
            :tilikauden_poistot => 0.0,
            :menojaannos => 0.0},
          "2984863744444" => {
            :tilikausi => "1.1.2015 - 31.12.2015",
            :hankinnat => 10000.0,
            :tilikauden_poistot => 0.0,
            :menojaannos => 0.0
          }
        }
      },
      "4443" => {
        :nimi => "Kiinteistöhankintatili",
        :poistoaika => 0,
        :hankinnat_yht => 0.0,
        :tilikauden_poistot_yht => 0,
        :menojaannos_yht => 0,
        :tilikaudet => {
          "9801909624443" => {
            :tilikausi => "1.1.2014 - 31.12.2014",
            :hankinnat => 0.0,
            :tilikauden_poistot => 0,
            :menojaannos => 0},
          "2984863744443" => {
            :tilikausi => "1.1.2015 - 31.12.2015",
            :hankinnat => 0.0,
            :tilikauden_poistot => 0,
            :menojaannos => 0
          }
        }
      }
    }

    assert_equal example_data, report.data
  end
end
