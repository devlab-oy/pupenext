class Head::PurchaseInvoice < Head
  # We have actually 5 types, that are saved in "tila".
  # Eventough it's supposed to be the STI column.
  INVOICE_TYPES = %w{H Y M P Q}

  # Child class will have the STI tables
  self.abstract_class = true

  # Make sure tila is correct
  validates :tila, inclusion: { in: INVOICE_TYPES }
end
