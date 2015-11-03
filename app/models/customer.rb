class Customer < BaseModel
  belongs_to :delivery_method,  foreign_key: :toimitustapa, primary_key: :selite
  belongs_to :category,
             class_name:  'Keyword::CustomerCategory',
             foreign_key: :luokka,
             primary_key: :selite
  belongs_to :subcategory,
             class_name:  'Keyword::CustomerSubcategory',
             foreign_key: :ryhma,
             primary_key: :selite
  belongs_to :terms_of_payment, foreign_key: :maksuehto

  has_many :customer_keywords, foreign_key: :liitostunnus
  has_many :prices, foreign_key: :asiakas, class_name: 'CustomerPrice'
  has_many :products, through: :prices
  has_many :transports

  default_scope { where.not(laji: %w(P R)) }

  self.table_name = :asiakas
  self.primary_key = :tunnus
  self.record_timestamps = false

  def contract_price?(product)
    product.in? products
  end
end
