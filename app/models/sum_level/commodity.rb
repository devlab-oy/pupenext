class SumLevel::Commodity < SumLevel
  has_many :accounts, primary_key: :yhtio, foreign_key: :yhtio

  validates_with SumLevelValidator

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    'E'
  end

  def poistovasta_account
    accounts.find_by_tilino(poisto_vastatili)
  end

  def poistoero_account
    accounts.find_by_tilino(poistoero_tili)
  end

  def poistoerovasta_account
    accounts.find_by_tilino(poistoero_vastatili)
  end
end
