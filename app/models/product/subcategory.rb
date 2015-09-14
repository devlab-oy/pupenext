class Product::Subcategory < Keyword
  has_many :products, foreign_key: :try, primary_key: :selite

  alias_attribute :tag, :selite
  alias_attribute :description, :selitetark

  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'TRY'
  end

  def categories
    company.categories.joins(:products).where(tuote: { try: selite })
  end

  def brands
    company.brands.joins(:products).where(tuote: { try: selite })
  end
end
