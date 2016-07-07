class Category::ProductsController < CategoriesController
  before_action :find_product_category, only: [:show, :children, :products]

  def index
    render json: Category::Product.roots
  end

  def show
    render json: @product_category
  end

  def tree
    render json: Category::Product.tree
  end

  def children
    render json: @product_category.children
  end

  def products
    render json: @product_category.products
  end

  private

    def find_product_category
      @product_category = Category::Product.find(params[:id])
    end
end
