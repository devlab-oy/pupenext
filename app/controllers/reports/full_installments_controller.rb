class Reports::FullInstallmentsController < ApplicationController
  def index
  end

  def run
    @data = Installment.includes(parent_order: [{ rows: :product }, :invoice])
      .where(osuus: 100, lasku: { alatila: :X }, tuote: { ei_saldoa: '' })
      .order("invoices_lasku.mapvm")

    respond_to do |format|
      format.html { render :report }
      format.xlsx { render :report }
    end
  end
end
