module PendingProductUpdateHelper
  def subcategories_options(args)
    return Current.company.subcategories if args[:osasto].nil? && args[:try].nil? && args[:tuotemerkki].nil?

    Product::Subcategory.subcategories(args[:try]) +
    Product::Category.subcategories(args[:osasto]) +
    Product::Brand.subcategories(args[:tuotemerkki])
  end
end
