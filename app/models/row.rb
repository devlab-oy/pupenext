class Row < BaseModel
  include PupenextSingleTableInheritance

  self.table_name = :tilausrivi
  self.primary_key = :tunnus
  self.inheritance_column = :tyyppi

  def self.default_child_instance
    child_class 'O'
  end

  def self.child_class_names
    {
      'O' => PurchaseOrder::Row,
      'V' => ManufactureOrder::Row,
    }
  end
end
