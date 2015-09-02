class Head::PurchaseInvoice < Head
  # Child class will have the STI tables
  self.abstract_class = true

  # We have actually 5 types, that are saved in "tila".
  # Eventough it's supposed to be the STI column.
  PURCHASE_INVOICE_TYPES = %w{H Y M P Q}

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    PURCHASE_INVOICE_TYPES
  end
end
