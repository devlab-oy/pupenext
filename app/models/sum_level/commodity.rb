class SumLevel::Commodity < SumLevel
  has_many :accounts, primary_key: :taso, foreign_key: :evl_taso

  validates_with SumLevelValidator

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    'E'
  end

  def poistovasta_account
    company.accounts.find_by_tilino(poisto_vastatili)
  end

  def poistoero_account
    company.accounts.find_by_tilino(poistoero_tili)
  end

  def poistoerovasta_account
    company.accounts.find_by_tilino(poistoero_vastatili)
  end
end
