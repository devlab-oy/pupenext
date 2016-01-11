class SumLevel::Profit < SumLevel
  has_many :accounts, primary_key: :taso, foreign_key: :tulosseuranta_taso

  validates :taso, numericality: { only_integer: true }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "B"
  end
end
