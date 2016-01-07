class Row < BaseModel
  include PupenextSingleTableInheritance

  self.table_name = :tilausrivi
  self.primary_key = :tunnus
  self.inheritance_column = :tyyppi

  before_create :set_defaults

  def self.default_child_instance
    child_class 'O'
  end

  def self.child_class_names
    {
      'G' => StockTransfer::Row,
      'L' => SalesOrder::Row,
      'M' => ManufactureOrder::RecursiveCompositeRow,
      'O' => PurchaseOrder::Row,
      'V' => ManufactureOrder::Row,
      'W' => ManufactureOrder::CompositeRow,
      '9' => SalesOrder::DetailRow,
    }
  end

  def self.reserved
    where.not(var: :P).where("tilausrivi.varattu > 0").sum(:varattu)
  end

  def self.picked
    where.not(keratty: '')
  end

  private

    def set_defaults
      # Date fields can be set to zero
      self.toimaika  ||= 0
      self.kerayspvm ||= 0

      # Datetime fields don't accept zero, so let's set them to epoch zero (temporarily)
      self.laadittu       ||= Time.at(0)
      self.kerattyaika    ||= Time.at(0)
      self.toimitettuaika ||= Time.at(0)
      self.laskutettuaika ||= Time.at(0)
    end
end
