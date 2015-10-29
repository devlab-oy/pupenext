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
      'A' => WorkOrder::Row,
      'E' => Preorder::Row,
      'G' => StockTransfer::Row,
      'L' => SalesOrder::Row,
      'O' => PurchaseOrder::Row,
      'R' => ProjectOrder::Row,
      'T' => OfferOrder::Row,
      'V' => ManufactureOrder::Row,
    }
  end

  def self.reserved
    where("tilausrivi.varattu > 0").sum(:varattu)
  end
end
