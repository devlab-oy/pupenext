class Reports::FullInstallmentsController < ApplicationController
  def index
  end

  def run
    # etsitään kaikki 100% maksupositiot (installment),
    # joiden parent order on avoin ja sales order on maksettu
    #
    # parent_order on alkuperäinen tilaus, jolle maksusopimus on tehty (loppulasku)
    # sales_order on tilaus, jolla ko. maksupositio on maksettu
    @data = Installment.includes(sales_order: :invoice, parent_order: [{ rows: :product }])
      .where(osuus: 100, lasku: { alatila: :X}, tuote: { ei_saldoa: '' })
      .where.not(parent_orders_maksupositio: { alatila: :X })
      .order("invoices_lasku.mapvm")

    render :report
  end
end
