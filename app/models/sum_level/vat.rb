class SumLevel::Vat < SumLevel
  has_many :accounts, primary_key: :taso, foreign_key: :alv_taso

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    'A'
  end
end
