class Qualifier::Project < Qualifier
  has_many :accounts, foreign_key: :projekti

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "P"
  end
end
