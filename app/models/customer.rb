class Customer < BaseModel
  belongs_to :terms_of_payment, foreign_key: :maksuehto
  belongs_to :category,
             class_name:  'Keyword::CustomerCategory',
             foreign_key: :osasto,
             primary_key: :selite
  belongs_to :subcategory,
             class_name:  'Keyword::CustomerSubcategory',
             foreign_key: :ryhma,
             primary_key: :selite
  has_many :transports, as: :transportable
  has_many :prices, foreign_key: :asiakas, class_name: 'CustomerPrice'
  has_many :products, through: :prices

  default_scope { where.not(laji: %w(P R)) }

  self.table_name = :asiakas
  self.primary_key = :tunnus
  self.record_timestamps = false

  def contract_price?(product)
    product.in? products
  end
end
