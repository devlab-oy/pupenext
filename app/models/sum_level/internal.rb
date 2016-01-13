class SumLevel::Internal < SumLevel
  has_many :accounts, primary_key: :taso, foreign_key: :sisainen_taso

  validates_with SumLevelValidator

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "S"
  end
end
