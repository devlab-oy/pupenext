class SumLevel::Vat < SumLevel
  default_scope { where(tyyppi: self.sti_name) }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    'A'
  end

  def self.human_readable_type
    "Alv"
  end
end
