class Head::PurchaseInvoice < Head
  # We have actually 5 types, that are saved in "tila".
  # Eventough it's supposed to be the STI column.
  INVOICE_TYPES = %w{H Y M P Q}

  scope :all_purchase_invoices, -> { where(tila: INVOICE_TYPES) }

  # Child class will have the STI tables
  self.abstract_class = true
end
