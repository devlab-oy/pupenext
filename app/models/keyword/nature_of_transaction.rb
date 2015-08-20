class Keyword::NatureOfTransaction < Keyword
  validates :selitetark, presence: true

  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'KT'
  end
end
