require 'test_helper'

class BalanceStatementsReportTest < ActiveSupport::TestCase
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
    report = BalanceStatementsReport.new(@company)

    example_data = {
      "10000" => {
        :nimi => "Koneet ja kalusto",
        :hankintameno => 10000.0,
        :kert_sumupoisto_before => 0.0,
        :sumupoisto => 0.0,
        :kert_sumupoisto_after => 0.0,
        :kert_poistoero_before => 0.0,
        :kert_poistoero => 111.0,
        :kert_poistoero_after => 111.0,
        :kert_evl_after => 1001.0,
        :poistamaton_osa => 10000.0
      },
      "10001" => {
        :nimi => "Kiinteistöt",
        :hankintameno => 0.0,
        :kert_sumupoisto_before => 0,
        :sumupoisto => 0,
        :kert_sumupoisto_after => 0,
        :kert_poistoero_before => 0,
        :kert_poistoero => 0,
        :kert_poistoero_after => 0,
        :kert_evl_after => 0,
        :poistamaton_osa => 0
      }
    }

    assert_equal example_data, report.data
  end
end
