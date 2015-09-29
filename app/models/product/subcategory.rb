class Product::Subcategory < Keyword
  include CategoryFilter

  has_many :products, foreign_key: :try, primary_key: :selite

  alias_attribute :tag, :selite
  alias_attribute :description, :selitetark

  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'TRY'
  end
end
