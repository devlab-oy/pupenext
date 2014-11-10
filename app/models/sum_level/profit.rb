class SumLevel::Profit < SumLevel
  validates :taso, numericality: { only_integer: true }

  default_scope { where(tyyppi: self.sti_name) }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "B"
  end
end
