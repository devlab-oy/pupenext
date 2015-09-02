class Keyword::RevenueExpenditureReportData < Keyword
  validates :selitetark, presence: true
  validates :selitetark_2, presence: true, numericality: true

  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'REVENUEREP'
  end
end
