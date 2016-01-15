class Customer < BaseModel
  belongs_to :category, foreign_key: :osasto, primary_key: :selite, class_name:  'Keyword::CustomerCategory'
  belongs_to :delivery_method, foreign_key: :toimitustapa, primary_key: :selite
  belongs_to :group, foreign_key: :luokka, primary_key: :selite, class_name:  'Keyword::CustomerGroup'
  belongs_to :subcategory, foreign_key: :ryhma, primary_key: :selite, class_name:  'Keyword::CustomerSubcategory'
  belongs_to :terms_of_payment, foreign_key: :maksuehto

  has_many :customer_keywords, foreign_key: :liitostunnus
  has_many :prices, foreign_key: :asiakas, class_name: 'CustomerPrice'
  has_many :products, through: :prices
  has_many :transports
  has_many :transports, as: :transportable

  default_scope { where.not(laji: %w(P R)) }

  self.table_name = :asiakas
  self.primary_key = :tunnus
  self.record_timestamps = false

  def contract_price?(product)
    product.in? products
  end
end
