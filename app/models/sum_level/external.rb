class SumLevel::External < SumLevel
  validates_with SumLevelValidator

  default_scope { where(tyyppi: self.sti_name) }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "U"
  end

  def self.human_readable_type
    "Ulkoinen"
  end
end
