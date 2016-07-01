class Reports::FullInstallmentsController < ApplicationController
  def index
  end

  def run
    @data = Installment.includes(:sales_order).where(osuus: 100, lasku: { alatila: :X })

    respond_to do |format|
      format.html
      format.xlsx
    end
  end
end
