class Keyword < BaseModel
  include PupenextSingleTableInheritance

  self.table_name         = :avainsana
  self.primary_key        = :tunnus
  self.inheritance_column = :laji

  validates :selite, presence: true

  def self.default_child_instance
    child_class :ALV
  end

  def self.child_class_names
    {
      ALV:            Keyword::Vat,
      ALVULK:         Keyword::ForeignVat,
      ASIAKASLUOKKA:  Keyword::CustomerGroup,
      ASIAKASOSASTO:  Keyword::CustomerCategory,
      ASIAKASRYHMA:   Keyword::CustomerSubcategory,
      ASIAKHIN_ATTR:  Keyword::CustomerPriceListAttribute,
      KM:             Keyword::ModeOfTransport,
      KT:             Keyword::NatureOfTransaction,
      LISATIETO:      Keyword::ProductInformationType,
      MAKSUEHTOKV:    Keyword::TermsOfPaymentTranslation,
      MYSQLALIAS:     Keyword::CustomAttribute,
      OSASTO:         Product::Category,
      PAKKAUSKV:      Keyword::PackageTranslation,
      PARAMETRI:      Keyword::ProductParameterType,
      REVENUEREP:     Keyword::RevenueExpenditure,
      S:              Product::Status,
      TERMINAALIALUE: Keyword::TerminalArea,
      TOIMTAPAKV:     Keyword::DeliveryMethodTranslation,
      TOIMTAPALP:     Keyword::SortingPoint,
      TRY:            Product::Subcategory,
      TULLI:          Keyword::Customs,
      TUOTEMERKKI:    Product::Brand,
      TUOTEULK:       Keyword::ProductKeywordType,
    }.stringify_keys
  end
end
