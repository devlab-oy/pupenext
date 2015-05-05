class ReportsController < ApplicationController
  def depreciations_balance_sheet
    # Tase-erittely sumu-poistoin
    @report = DepreciationsBalanceSheetReport.new(current_company)
  end

  def depreciation_difference
    # Poistoeroraportti
    @report = DepreciationDifferenceReport.new(current_company)
  end

  def balance_statements
    # Tilinpäätöksen liitetiedot
    @report = BalanceStatementsReport.new(current_company)
    @data = @report.data
  end
end
