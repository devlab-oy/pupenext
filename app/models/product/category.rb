class Product::Category < Keyword
  has_many :products, foreign_key: :osasto, primary_key: :selite

  alias_attribute :tag, :selite
  alias_attribute :description, :selitetark

  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'OSASTO'
  end

  def subcategories
    company.subcategories.joins(:products).where(tuote: { osasto: selite })
  end

  def brands
    company.brands.joins(:products).where(tuote: { osasto: selite })
  end
end
