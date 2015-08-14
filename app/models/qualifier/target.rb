class Qualifier::Target < Qualifier
  has_many :accounts, foreign_key: :kohde

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "O"
  end
end
