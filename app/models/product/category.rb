class Product::Category < Keyword
  has_many :products, foreign_key: :osasto, primary_key: :selite

  alias_attribute :tag, :selite
  alias_attribute :description, :selitetark

  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'OSASTO'
  end

  def self.categories(osasto)
    Current.company.categories.joins(:products).where(tuote: { osasto: osasto }).pluck(:selite, :selitetark)
  end

  def self.subcategories(osasto)
    Current.company.subcategories.joins(:products).where(tuote: { osasto: osasto }).pluck(:selite, :selitetark)
  end

  def self.brands(osasto)
    Current.company.brands.joins(:products).where(tuote: { osasto: osasto }).pluck(:selite, :selitetark)
  end
end
