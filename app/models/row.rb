class Row < BaseModel
  include PupenextSingleTableInheritance

  belongs_to :order, foreign_key: :otunnus, class_name: 'SalesOrder::Base'
  belongs_to :product, primary_key: :tuoteno, foreign_key: :tuoteno
  belongs_to :warehouse, foreign_key: :varasto

  validates :product, presence: true

  self.table_name = :tilausrivi
  self.primary_key = :tunnus
  self.inheritance_column = :tyyppi

  def parent?
    tunnus == perheid
  end

  def self.default_child_instance
    child_class 'O'
  end

  def self.child_class_names
    {
      '9' => SalesOrder::DetailRow,
      'G' => StockTransfer::Row,
      'L' => SalesOrder::Row,
      'M' => ManufactureOrder::RecursiveCompositeRow,
      'O' => PurchaseOrder::Row,
      'V' => ManufactureOrder::Row,
      'W' => ManufactureOrder::CompositeRow,
    }
  end

  def self.reserved
    where.not(var: :P).where("tilausrivi.varattu > 0").sum(:varattu)
  end

  def self.picked
    where.not(keratty: '')
  end
end
