module ProductHelper
  def categories_options(args = {})
    Product::Category.filter(args).pluck(:description, :tag).uniq
  end

  def subcategories_options(args = {})
    Product::Subcategory.filter(args).pluck(:description, :tag).uniq
  end

  def brands_options(args = {})
    Product::Brand.filter(args).pluck(:name).uniq
  end
end
