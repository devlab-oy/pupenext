class Reports::CommodityReportsController < ApplicationController

  def index
  end

  def depreciations_balance_sheet
    # Tase-erittely sumu-poistoin
    @report = DepreciationsBalanceSheetReport.new(Current.company)
  end

  def depreciation_difference
    # Poistoeroraportti
    @report = DepreciationDifferenceReport.new(Current.company)
  end

  def balance_statements
    # Tilinpäätöksen liitetiedot
    @report = BalanceStatementsReport.new(Current.company)
  end
end
