class Product::Group < Keyword
  has_many :products, foreign_key: :osasto, primary_key: :selite

  alias_attribute :value, :selite
  alias_attribute :name, :selitetark

  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'OSASTO'
  end
end
