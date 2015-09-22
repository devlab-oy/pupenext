class Head::SalesInvoiceRow < BaseModel

  belongs_to :invoice, foreign_key: :uusiotunnus, class_name: 'Head::SalesInvoice'
  belongs_to :product, foreign_key: :tuoteno, primary_key: :tuoteno

  default_scope { where(tyyppi: 'L') }
  default_scope { where.not(var: %w(P J O S)) }

  self.table_name = :tilausrivi
  self.primary_key = :tunnus

  def delivery_date
    if company.parameter.manual_deliverydates_for_all_products? ||
      (company.parameter.manual_deliverydates_when_product_inventory_not_managed? &&
        product.no_inventory_management?)
      toimaika
    else
      toimitettuaika.to_date
    end
  end
end
