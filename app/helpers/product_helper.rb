module ProductHelper
  def categories_options
    options_for_select(
      Product::Category.filter(args).pluck(:description, :tag).uniq,
      params[:osasto]
    )
  end

  def subcategories_options
    options_for_select(
      Product::Subcategory.filter(args).pluck(:description, :tag).uniq,
      params[:try]
    )
  end

  def brands_options
    options_for_select(
      Product::Brand.filter(args).pluck(:name).uniq,
      params[:tuotemerkki]
    )
  end

  private

    def args
      {
        categories:    params[:osasto],
        subcategories: params[:try],
        brands:        params[:tuotemerkki]
      }
    end
end
