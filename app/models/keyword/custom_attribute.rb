class Keyword::CustomAttribute < Keyword
  validates :selitetark, presence: true
  validates :selitetark_2, uniqueness: { scope: [:selite] }

  enum selitetark_3: {
    optional: '',
    mandatory: 'PAKOLLINEN',
  }

  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'MYSQLALIAS'
  end
end

