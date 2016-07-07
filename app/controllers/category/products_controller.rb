class Category::ProductsController < CategoriesController
  before_action :find_product_category, only: :children

  def index
    render json: Category::Product.roots
  end

  def tree
    render json: Category::Product.tree
  end

  def children
    render json: @product_category.children
  end

  private

    def find_product_category
      @product_category = Category::Product.find(params[:id])
    end
end
