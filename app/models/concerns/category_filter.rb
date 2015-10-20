module CategoryFilter
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(categories: nil, subcategories: nil, brands: nil)
      products = Product
      products = products.where(tuote: { osasto: categories }) if categories.present?
      products = products.where(tuote: { try: subcategories }) if subcategories.present?
      products = products.where(tuote: { tuotemerkki: brands }) if brands.present?

      if categories.present? || subcategories.present? || brands.present?
        response = joins(:products).where(tuote: { tunnus: products })
      else
        response = all
      end

      response.order(:jarjestys, :selite, :selitetark)
    end
  end
end
