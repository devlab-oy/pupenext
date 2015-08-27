class Head::SalesOrder < Head
  validates :tila, inclusion: { in: ['L'] }

  scope :not_delivered, -> { where(alatila: %w(A B C)) }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "L"
  end
end
