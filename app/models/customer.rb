class Customer < BaseModel
  belongs_to :terms_of_payment, foreign_key: :maksuehto

  with_options primary_key: :selite do |o|
    o.belongs_to :category,        foreign_key: :osasto, class_name: 'Keyword::CustomerCategory'
    o.belongs_to :subcategory,     foreign_key: :ryhma,  class_name: 'Keyword::CustomerSubcategory'
    o.belongs_to :delivery_method, foreign_key: :toimitustapa
  end

  has_many :prices, foreign_key: :asiakas, class_name: 'CustomerPrice'
  has_many :products, through: :prices
  has_many :sales_details, foreign_key: :liitostunnus, class_name: 'SalesOrder::Detail'
  has_many :transports, as: :transportable

  validates :ytunnus, presence: true, uniqueness: { scope: :yhtio }
  validates :asiakasnro, uniqueness: { scope: :yhtio }, allow_blank: true
  validates :nimi, presence: true
  validates :maa, inclusion: { in: Country.pluck(:koodi) }
  validates :ryhma, inclusion: { in: ->(c) { c.company.keywords.where(laji: :asiakasryhma).pluck(:selite) } }
  validates :osasto, inclusion: { in: ->(c) { c.company.keywords.where(laji: :asiakasosasto).pluck(:selite) } }

  validate :validate_chn

  before_validation :defaults

  default_scope { where.not(laji: %w(P R)) }

  self.table_name = :asiakas
  self.primary_key = :tunnus
  self.record_timestamps = false

  def contract_price?(product)
    product.in? products
  end

  # Limit the json data for API request
  def as_json(options = {})
    {
      tunnus:     tunnus,
      ytunnus:    ytunnus,
      asiakasnro: asiakasnro,
      nimi:       nimi,
      nimitark:   nimitark,
      osoite:     osoite,
      postino:    postino,
      postitp:    postitp,
      maa:        maa,
      toim_maa:   toim_maa,
      email:      email,
      puhelin:    puhelin,
      kieli:      kieli
    }
  end

  private

    def defaults
      self.kieli = 'fi' if kieli.blank?
      self.chn = '100' if chn.blank?
      self.alv = company.keywords.where(laji: :alv).where.not(selitetark: '').first if alv.blank?
      self.toimitustapa = company.delivery_methods.first if toimitustapa.blank?
      self.kauppatapahtuman_luonne = company.keywords.where(laji: :kt).first if kauppatapahtuman_luonne.blank?
      self.lahetetyyppi = company.keywords.where(laji: :lahetetyyppi).first if lahetetyyppi.blank?
      self.maa = 'fi' if maa.blank?
      self.kansalaisuus = maa if kansalaisuus.blank?
      self.toim_maa = maa if toim_maa.blank?
      self.kolm_maa = maa if kolm_maa.blank?
      self.laskutus_maa = maa if laskutus_maa.blank?
      self.valkoodi = company.currencies.first.try(:nimi) if valkoodi.blank?
      self.maksuehto = company.terms_of_payments.first if maksuehto.blank?
      self.laskutyyppi = -9 if laskutyyppi.blank?
    end

    def validate_chn
      if chn == '666' && email.blank?
        errors.add(:chn, 'Olet valinnut laskutustavaksi sähköpostin ja lasku_email on tyhjä! Laskutus ei onnistu')
      end
    end
end
