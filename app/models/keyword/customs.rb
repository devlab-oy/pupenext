class Keyword::Customs < Keyword
  validates :selite, length: 1..3
  validates :selitetark, presence: true

  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'TULLI'
  end
end
