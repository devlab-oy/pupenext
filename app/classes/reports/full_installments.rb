class Reports::FullInstallments
  def initialize
    raise ArgumentError unless Current.company
    raise ArgumentError unless Current.user
  end

  def run
    result = data(:parent_order) + data(:parent_draft)
    result.sort_by { |row| row[:paid_at] }
  end

  private

    def data(relation)
      # rakennetaan sopiva hashi
      data = []

      fetch(relation).each do |installment|
        installment.send(relation).rows.each do |row|
          data << {
            avg_acquisition_cost: row.product.kehahin,
            customer: installment.send(relation).nimi,
            inventory_value: (row.reserved * row.product.kehahin),
            invoice: installment.sales_order.laskunro,
            order: installment.send(relation).tunnus,
            paid_at: installment.sales_order.invoice.mapvm,
            qty: row.reserved,
            sku: row.tuoteno,
            unit: row.product.yksikko,
          }
        end
      end

      data
    end

    def fetch(relation)
      # etsitään kaikki 100% maksupositiot (installment),
      # joiden parent order on avoin ja sales order on maksettu
      #
      # parent_order on alkuperäinen tilaus, jolle maksusopimus on tehty (loppulasku)
      # sales_order on tilaus, jolla ko. maksupositio on maksettu

      table = "#{relation}s_maksupositio"

      Installment.includes(sales_order: :invoice, relation => [{ rows: :product }])
        .where(osuus: 100, lasku: { alatila: :X }, tuote: { ei_saldoa: '' })
        .where("invoices_lasku.mapvm != '0000-00-00'")
        .where.not(table => { alatila: :X })
    end
end
