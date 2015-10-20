class Head::SalesOrder < Head
  has_many :rows, foreign_key: :otunnus, class_name: 'Head::SalesOrder::Row'
  # Child class will have the STI tables
  self.abstract_class = true

  # We have actually 2 types, that are saved in "tila".
  TYPES = %w{L N}
end
