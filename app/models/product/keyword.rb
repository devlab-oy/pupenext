class Product::Keyword < BaseModel
  belongs_to :product, foreign_key: :tuoteno, primary_key: :tuoteno

  self.table_name = :tuotteen_avainsanat
  self.primary_key = :tunnus

  validates :kieli, presence: true
  validates :laji, presence: true, uniqueness: { scope: [:yhtio, :tuoteno, :laji, :kieli] }
  validates :product, presence: true
  validates :selite, presence: true

  validate :laji_value_inclusion

  alias_attribute :description, :selitetark
  alias_attribute :key, :laji
  alias_attribute :locale, :kieli
  alias_attribute :order, :jarjestys
  alias_attribute :value, :selite
  alias_attribute :visibility, :nakyvyys

  private

    def laji_value_inclusion
      # don't run this validation if we already have other errors (because this is slow)
      return if errors.present?

      unless allowed_laji_values.include? laji
        errors.add :laji, I18n.t('errors.messages.inclusion')
      end
    end

    def cache_key
      key = ['product-keyword']
      key << product.company.id

      count = Keyword::ProductInformationType.count
      key << count
      key << Keyword::ProductInformationType.maximum(:muutospvm).try(:utc).try(:to_s, :number) if count.nonzero?

      count = Keyword::ProductKeywordType.count
      key << count
      key << Keyword::ProductKeywordType.maximum(:muutospvm).try(:utc).try(:to_s, :number) if count.nonzero?

      count = Keyword::ProductParameterType.count
      key << count
      key << Keyword::ProductParameterType.maximum(:muutospvm).try(:utc).try(:to_s, :number) if count.nonzero?

      key.join '/'
    end

    def allowed_laji_values
      Rails.cache.fetch(cache_key) do
        Keyword::ProductInformationType.pluck(:selite).map { |a| "lisatieto_#{a}" } +
        Keyword::ProductKeywordType.pluck(:selite) +
        Keyword::ProductParameterType.pluck(:selite).map { |a| "parametri_#{a}" } +
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
end
