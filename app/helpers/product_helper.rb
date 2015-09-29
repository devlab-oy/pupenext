module ProductHelper
  def categories_options(args = {})
    if args[:category].nil? && args[:subcategory].nil? && args[:brand].nil?
      return Current.company.categories.pluck(:selite, :selitetark)
    end

    result = Product::Subcategory.categories(args[:subcategory]) +
             Product::Category.categories(args[:category]) +
             Product::Brand.categories(args[:brand])
    result.uniq!
    result
  end

  def subcategories_options(args = {})
    if args[:category].nil? && args[:subcategory].nil? && args[:brand].nil?
      return Current.company.subcategories.pluck(:selite, :selitetark)
    end

    result = Product::Subcategory.subcategories(args[:subcategory]) +
             Product::Category.subcategories(args[:category]) +
             Product::Brand.subcategories(args[:brand])
    result.uniq!
    result
  end

  def brands_options(args = {})
    if args[:category].nil? && args[:subcategory].nil? && args[:brand].nil?
      return Current.company.brands.pluck(:selite)
    end

    result = Product::Subcategory.brands(args[:subcategory]) +
             Product::Category.brands(args[:category]) +
             Product::Brand.brands(args[:brand])
    result.uniq!
    result
  end
end
