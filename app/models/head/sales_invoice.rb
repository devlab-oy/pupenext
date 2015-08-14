class Head::SalesInvoice < Head
  validates :tila, inclusion: { in: ['U'] }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "U"
  end

  def self.human_readable_type
    "Myyntilasku"
  end
end
