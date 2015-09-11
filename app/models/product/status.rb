class Product::Status < Keyword
  has_many :products, foreign_key: :status, primary_key: :selite

  alias_attribute :tag, :selite
  alias_attribute :description, :selitetark

  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'S'
  end
end
