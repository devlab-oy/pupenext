class Head::SalesInvoice < Head
  validates :tila, inclusion: { in: ['U'] }
  has_many :rows, foreign_key: :uusiotunnus, class_name: 'Head::SalesInvoiceRow'
  
  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "U"
  end
end
