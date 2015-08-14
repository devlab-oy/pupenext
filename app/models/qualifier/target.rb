class Qualifier::Target < Qualifier
  has_many :accounts, foreign_key: :kohde

  def self.human_readable_type
    "Kohde"
  end

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "O"
  end
end
