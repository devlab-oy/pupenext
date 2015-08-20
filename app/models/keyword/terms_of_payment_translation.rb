class Keyword::TermsOfPaymentTranslation < Keyword
  belongs_to :terms_of_payment, foreign_key: :selite

  validates :selitetark, presence: true
  validates :kieli, inclusion: { in: %w{ee en no se de dk ru} }
  validates :kieli, uniqueness: { scope: [:yhtio, :selite] }

  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'MAKSUEHTOKV'
  end
end
