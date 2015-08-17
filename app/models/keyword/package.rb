class Keyword::Package < Keyword
  validates :selitetark, presence: true

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    'PAKKAUSKV'
  end
end
