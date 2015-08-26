class Keyword < BaseModel
  include PupenextSingleTableInheritance

  self.table_name = :avainsana
  self.primary_key = :tunnus
  self.inheritance_column = :laji

  validates :selite, presence: true

  def self.default_child_instance
    child_class 'ALV'
  end

  def self.child_class_names
    {
      'ALV' => Keyword::Vat,
      'ALVULK' => Keyword::ForeignVat,
      'MAKSUEHTOKV' => Keyword::TermsOfPaymentTranslation
    }
  end
end
