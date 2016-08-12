class PurchaseOrder::Row < Row
  belongs_to :order, foreign_key: :otunnus, class_name: 'PurchaseOrder::Order'
  belongs_to :arrival, -> { where(vanhatunnus: 0) }, foreign_key: :uusiotunnus

  validates :tyyppi, inclusion: { in: ['O'] }

  scope :complete_in_stock, -> { includes(:arrival).where.not(lasku: { mapvm: '0000-00-00' }) }
  scope :incomplete_in_stock, -> { includes(:arrival).where(lasku: { mapvm: '0000-00-00' }) }
  scope :open, -> { where("(tilausrivi.varattu + tilausrivi.jt) > 0 AND tilausrivi.laskutettuaika = '0000-00-00'") }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    'O'
  end
end
