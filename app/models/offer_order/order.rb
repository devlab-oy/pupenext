class OfferOrder::Order < Head
  has_many :rows, foreign_key: :otunnus, class_name: 'OfferOrder::Row'

  validates :tila, inclusion: { in: ['T'] }

  scope :printed_and_accepted, -> { where(alatila: %W(#{} A B)) }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "T"
  end
end
