class Row < BaseModel
  include PupenextSingleTableInheritance

  belongs_to :order, foreign_key: :otunnus, class_name: 'SalesOrder::Base'
  belongs_to :product, primary_key: :tuoteno, foreign_key: :tuoteno

  validates :product, presence: true

  before_create :set_defaults
  after_create :fix_datetime_fields

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

    def fix_datetime_fields
      params  = {}
      zero    = '0000-00-00 00:00:00'
      epoch   = Time.at(0)

      # Change all datetime fields to zero if they are epoch
      params[:laadittu]       = zero if laadittu       == epoch
      params[:kerattyaika]    = zero if kerattyaika    == epoch
      params[:toimitettuaika] = zero if toimitettuaika == epoch
      params[:laskutettuaika] = zero if laskutettuaika == epoch

      # update_columns skips all validations and updates values directly with sql
      update_columns params if params.present?
    end
end
