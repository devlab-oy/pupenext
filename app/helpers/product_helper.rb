module ProductHelper
  def categories_options
    options_for_select category_filter, params[:osasto]
  end

  def subcategories_options
    options_for_select subcategory_filter, params[:try]
  end

  def brands_options
    options_for_select brand_filter, params[:tuotemerkki]
  end

  private

    def category_filter
      Product::Category.where(kieli: current_user.locale)
        .order(:jarjestys, :selite, :selitetark)
        .map { |c| ["#{c.tag} - #{c.description}", c.tag] }.uniq
    end

    def subcategory_filter
      Product::Subcategory.where(kieli: current_user.locale)
        .filter(categories: params[:osasto])
        .map { |c| ["#{c.tag} - #{c.description}", c.tag] }.uniq
    end

    def brand_filter
      Product::Brand.where(kieli: current_user.locale)
        .filter(categories: params[:osasto], subcategories: params[:try])
        .pluck(:name).uniq
    end
end
