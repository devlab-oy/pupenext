module ProductHelper
  def categories_options
    options_for_select category_filter, params[:osasto]
  end

  def subcategories_options
    options_for_select subcatecory_filter, params[:try]
  end

  def brands_options
    options_for_select brand_filter, params[:tuotemerkki]
  end

  private

    def category_filter
      Product::Category.where(kieli: current_user.locale).pluck(:description, :tag).uniq
    end

    def subcatecory_filter
      Product::Subcategory.where(kieli: current_user.locale).filter(categories: params[:osasto]).pluck(:description, :tag).uniq
    end

    def brand_filter
      Product::Brand.where(kieli: current_user.locale).filter(categories: params[:osasto], subcategories: params[:try]).pluck(:name).uniq
    end
end
