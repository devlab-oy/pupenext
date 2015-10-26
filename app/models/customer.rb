class Customer < BaseModel
  belongs_to :terms_of_payment, foreign_key: :maksuehto
  belongs_to :subcategory,
             class_name:  'Keyword::CustomerSubcategory',
             foreign_key: :ryhma,
             primary_key: :selite
  has_many :transports

  default_scope { where.not(laji: %w(P R)) }

  self.table_name = :asiakas
  self.primary_key = :tunnus
  self.record_timestamps = false
end
