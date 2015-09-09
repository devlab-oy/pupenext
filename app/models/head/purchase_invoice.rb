class Head::PurchaseInvoice < Head
  # Child class will have the STI tables
  self.abstract_class = true

  # We have actually 5 types, that are saved in "tila".
  TYPES = %w{H Y M P Q}
end
