module PendingProductUpdateHelper
  def categories_options(args = {})
    return Current.company.categories if args[:osasto].nil? && args[:try].nil? && args[:tuotemerkki].nil?

    result = Product::Subcategory.categories(args[:try]) +
             Product::Category.categories(args[:osasto]) +
             Product::Brand.categories(args[:tuotemerkki])
    result.uniq!
    result
  end

  def subcategories_options(args = {})
    return Current.company.subcategories if args[:osasto].nil? && args[:try].nil? && args[:tuotemerkki].nil?

    result = Product::Subcategory.subcategories(args[:try]) +
             Product::Category.subcategories(args[:osasto]) +
             Product::Brand.subcategories(args[:tuotemerkki])
    result.uniq!
    result
  end

  def brands_options(args = {})
    return Current.company.brands if args[:osasto].nil? && args[:try].nil? && args[:tuotemerkki].nil?

    result = Product::Subcategory.brands(args[:try]) +
             Product::Category.brands(args[:osasto]) +
             Product::Brand.brands(args[:tuotemerkki])
    result.uniq!
    result
  end
end
