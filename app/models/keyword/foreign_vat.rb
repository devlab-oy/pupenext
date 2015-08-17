class Keyword::ForeignVat < Keyword
  validates :selitetark_2, presence: true

  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'ALVULK'
  end
end
