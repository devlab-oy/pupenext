class Product::Brand < Keyword
  has_many :products, foreign_key: :tuotemerkki, primary_key: :selite

  alias_attribute :tag, :selite

  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'TUOTEMERKKI'
  end

  def categories
    company.categories.joins(:products).where(tuote: { tuotemerkki: selite })
  end

  def subcategories
    company.subcategories.joins(:products).where(tuote: { tuotemerkki: selite })
  end
end
