class Customer < BaseModel
  belongs_to :terms_of_payment, foreign_key: :maksuehto

  with_options primary_key: :selite do |o|
    o.belongs_to :category,    foreign_key: :osasto, class_name: 'Keyword::CustomerCategory'
    o.belongs_to :subcategory, foreign_key: :ryhma,  class_name: 'Keyword::CustomerSubcategory'
  end

  has_many :prices, foreign_key: :asiakas, class_name: 'CustomerPrice'
  has_many :products, through: :prices
  has_many :sales_details, foreign_key: :liitostunnus, class_name: 'SalesOrder::Detail'
  has_many :transports, as: :transportable

  validates :asiakasnro, presence: true, uniqueness: true
  validate :validate_chn, on: [:create, :update]

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
      ytunnus:    self.ytunnus,
      asiakasnro: self.asiakasnro,
      nimi:       self.nimi,
      nimitark:   self.nimitark,
      osoite:     self.osoite,
      postino:    self.postino,
      postitp:    self.postitp,
      maa:        self.maa,
      toim_maa:   self.toim_maa,
      email:      self.email,
      puhelin:    self.puhelin,
      kieli:      self.kieli,
      chn:        self.chn
    }
  end

  private

    def validate_chn
      if chn == '666' && email.empty? &&
        errors.add(:chn, 'Olet valinnut laskutustavaksi sähköpostin ja lasku_email on tyhjä! Laskutus ei onnistu')
      end
    end
end
