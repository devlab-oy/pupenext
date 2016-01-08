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

  validates :asiakasnro, uniqueness: { scope: :yhtio }, allow_blank: true
  validates :maa, inclusion: { in: proc { Country.pluck(:koodi) } }
  validates :nimi, presence: true
  validates :osasto, inclusion: { in: ->(c) { c.company.keywords.where(laji: :asiakasosasto).pluck(:selite) } }
  validates :ryhma, inclusion: { in: ->(c) { c.company.keywords.where(laji: :asiakasryhma).pluck(:selite) } }
  validates :ytunnus, presence: true, uniqueness: { scope: :yhtio }

  validate :validate_chn
  validate :validate_delivery_method

  before_validation :defaults

  default_scope { where.not(laji: %w(P R)) }

  self.table_name = :asiakas
  self.primary_key = :tunnus
  self.record_timestamps = false

  def maa=(value)
    write_attribute(:maa, value.upcase)
  end

  def contract_price?(product)
    product.in? products
  end

  # Limit the json data for API request
  def as_json(options = {})
    {
      asiakasnro: asiakasnro,
      email:      email,
      kieli:      kieli,
      maa:        maa,
      nimi:       nimi,
      nimitark:   nimitark,
      osoite:     osoite,
      postino:    postino,
      postitp:    postitp,
      puhelin:    puhelin,
      toim_maa:   toim_maa,
      tunnus:     tunnus,
      ytunnus:    ytunnus,
    }
  end

  private

    def defaults
      self.laji = 'H' if laji.blank?
      self.kieli = 'fi' if kieli.blank?
      self.chn = '100' if chn.blank?
      self.alv = company.keywords.where(laji: :alv).where.not(selitetark: '').first.try(:selite) if alv.blank?
      self.toimitustapa = company.delivery_methods.first if toimitustapa.blank?
      self.kauppatapahtuman_luonne = company.keywords.where(laji: :kt).first.try(:selite) if kauppatapahtuman_luonne.blank?
      self.lahetetyyppi = company.keywords.where(laji: :lahetetyyppi).first.try(:selite) if lahetetyyppi.blank?
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

    def validate_delivery_method
      delivery_method = company.delivery_methods.where(selite: toimitustapa).first
      if delivery_method.sallitut_maat != "" && delivery_method.sallitut_maat != maa
        errors.add(:toimitustapa, "Tätä maksuehtoa ei saa käyttää asiakkaalla tässä maassa.")
      end
    end
end
