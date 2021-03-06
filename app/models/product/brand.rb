class Product::Brand < Keyword
  include CategoryFilter

  has_many :products, foreign_key: :tuotemerkki, primary_key: :selite

  alias_attribute :name, :selite

  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'TUOTEMERKKI'
  end
end
