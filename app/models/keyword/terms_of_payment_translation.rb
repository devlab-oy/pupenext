class Keyword::TermsOfPaymentTranslation < Keyword
  belongs_to :terms_of_payment, foreign_key: :selite, primary_key: :tunnus

  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'MAKSUEHTOKV'
  end
end
