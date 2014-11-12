class SumLevel::Internal < SumLevel
  validates_with SumLevelValidator

  default_scope { where(tyyppi: self.sti_name) }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "S"
  end

  def self.human_readable_type
    "Sisäinen"
  end
end
