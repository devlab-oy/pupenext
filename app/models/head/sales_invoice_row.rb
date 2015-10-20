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

  def vat_percent
    if alv >= 500
      0.0.to_d
    else
      alv
    end
  end

  def vat_code(vat_rate)
    if vat_rate >= 600
      "AE" # VAT Reverse Charge
    elsif vat_rate >= 500
      "AB" # Exempt for resale
    elsif vienti == "E"
      "E" # Exempt from tax
    elsif vienti == "K"
      "G" # Free export item, tax not charged
    else
      "S" # Standard rate
    end
  end
end
