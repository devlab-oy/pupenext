module ProductHelper
  def categories_options(args = nil)
    Product::Category.filter(args).pluck(:tag, :description).uniq
  end

  def subcategories_options(args = nil)
    Product::Subcategory.filter(args).pluck(:tag, :description).uniq
  end

  def brands_options(args = nil)
    Product::Brand.filter(args).pluck(:name).uniq
  end
end
