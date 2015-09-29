class Product::Brand < Keyword
  has_many :products, foreign_key: :tuotemerkki, primary_key: :selite

  alias_attribute :tag, :selite

  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'TUOTEMERKKI'
  end

  def self.categories(merkki)
    Current.company.categories.joins(:products).where(tuote: { tuotemerkki: merkki }).pluck(:selite)
  end

  def self.subcategories(merkki)
    Current.company.subcategories.joins(:products).where(tuote: { tuotemerkki: merkki }).pluck(:selite)
  end

  def self.brands(merkki)
    Current.company.brands.joins(:products).where(tuote: { tuotemerkki: merkki }).pluck(:selite)
  end
end
