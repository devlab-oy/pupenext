class SumLevel::Vat < SumLevel
  has_many :accounts, foreign_key: :alv_taso

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    'A'
  end

  def self.human_readable_type
    "ALV"
  end
end
