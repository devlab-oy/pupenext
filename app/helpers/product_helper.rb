module ProductHelper
  def categories_options(args = {})
    Product::Category.filter(params).pluck(:tag, :description).uniq
  end

  def subcategories_options(args = {})
    Product::Subcategory.filter(params).pluck(:tag, :description).uniq
  end

  def brands_options(args = {})
    Product::Brand.filter(params).pluck(:name).uniq
  end
end
