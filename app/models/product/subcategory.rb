class Product::Subcategory < Keyword
  has_many :products, foreign_key: :try, primary_key: :selite

  alias_attribute :tag, :selite
  alias_attribute :description, :selitetark

  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'TRY'
  end

  def self.subcategories(try)
    Current.company.subcategories.joins(:products).where(tuote: { try: try })
  end

  def self.categories(try)
    Current.company.categories.joins(:products).where(tuote: { try: try })
  end

  def self.brands(try)
    Current.company.brands.joins(:products).where(tuote: { try: try })
  end
end
