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

    def args
      {
        categories:    params[:osasto],
        subcategories: params[:try],
        brands:        params[:tuotemerkki]
      }
    end

    def category_filter
      Product::Category.filter(args).pluck(:description, :tag).uniq
    end

    def subcatecory_filter
      Product::Subcategory.filter(args).pluck(:description, :tag).uniq
    end

    def brand_filter
      Product::Brand.filter(args).pluck(:name).uniq
    end
end
