class Keyword < BaseModel
  include PupenextSingleTableInheritance

  def self.mode_of_transports
    where(laji: "KM")
  end

  def self.nature_of_transactions
    where(laji: "KT")
  end

  def self.customs
    where(laji: "TULLI")
  end

  def self.sorting_points
    where(laji: "TOIMTAPALP")
  end

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
      'MAKSUEHTOKV' => Keyword::TermsOfPaymentTranslation,
      'RAHTIKIRJA' => Keyword::Waybill
    }
  end
end
