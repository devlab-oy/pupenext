module PendingProductUpdateHelper
  def categories_options(args = {})
    return Current.company.categories if args[:category].nil? && args[:subcategory].nil? && args[:brand].nil?

    result = Product::Subcategory.categories(args[:subcategory]) +
             Product::Category.categories(args[:category]) +
             Product::Brand.categories(args[:brand])
    result.uniq!
    result
  end

  def subcategories_options(args = {})
    return Current.company.subcategories if args[:category].nil? && args[:subcategory].nil? && args[:brand].nil?

    result = Product::Subcategory.subcategories(args[:subcategory]) +
             Product::Category.subcategories(args[:category]) +
             Product::Brand.subcategories(args[:brand])
    result.uniq!
    result
  end

  def brands_options(args = {})
    return Current.company.brands if args[:category].nil? && args[:subcategory].nil? && args[:brand].nil?

    result = Product::Subcategory.brands(args[:subcategory]) +
             Product::Category.brands(args[:category]) +
             Product::Brand.brands(args[:brand])
    result.uniq!
    result
  end
end
