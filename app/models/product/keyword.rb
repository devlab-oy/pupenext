class Product::Keyword < BaseModel
  belongs_to :product, foreign_key: :tuoteno, primary_key: :tuoteno

  validate :laji_value_inclusion

  self.table_name = :tuotteen_avainsanat
  self.primary_key = :tunnus

  alias_attribute :description, :selitetark
  alias_attribute :key, :laji
  alias_attribute :locale, :kieli
  alias_attribute :order, :jarjestys
  alias_attribute :value, :selite
  alias_attribute :visibility, :nakyvyys

  private

    def laji_value_inclusion
      unless allowed_laji_values.include? laji
        errors.add :laji, I18n.t('errors.messages.inclusion')
      end
    end

    def allowed_laji_values
      Keyword::ProductInformationType.pluck(:selite) +
      Keyword::ProductKeywordType.pluck(:selite) +
      Keyword::ProductParameterType.pluck(:selite) +
      %w(
        ei_edi_ostotilaukseen
        hammastus
        hinnastoryhmittely
        kuvaus
        laatuluokka
        lyhytkuvaus
        mainosteksti
        nimitys
        oletusvalinta
        osasto
        sistoimittaja
        synkronointi
        tarratyyppi
        toimpalautus
        try
        varastopalautus
      )
    end
end
