class Qualifier::CostCenter < Qualifier
  has_many :accounts, foreign_key: :kustp

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "K"
  end
end
