class Product::Group < Keyword
  has_many :products, foreign_key: :osasto, primary_key: :selite

  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'OSASTO'
  end
end
