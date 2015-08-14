class SumLevel::External < SumLevel
  has_many :accounts, foreign_key: :ulkoinen_taso

  validates_with SumLevelValidator

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "U"
  end

  def self.human_readable_type
    "Ulkoinen"
  end
end
