class Head::SalesOrderDraft < Head
  validates :tila, inclusion: { in: ['N'] }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "N"
  end
end
