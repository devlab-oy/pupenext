module CategoryFilter
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(categories: nil, subcategories: nil, brands: nil)
      products = Product.all
      products = products.where(tuote: { osasto: categories }) if categories
      products = products.where(tuote: { try: subcategories }) if subcategories
      products = products.where(tuote: { tuotemerkki: brands }) if brands

      joins(:products).where(tuote: { tunnus: products })
    end
  end
end
