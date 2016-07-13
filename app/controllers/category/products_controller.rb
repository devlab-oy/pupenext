class Category::ProductsController < CategoriesController
  before_action :find_product_category, only: [:show, :children, :products]

  def index
    render json: Category::Product.all
  end

  def show
    render json: @product_category
  end

  def tree
    render json: Category::Product.tree
  end

  def roots
    render json: Category::Product.roots
  end

  def children
    render json: @product_category.children
  end

  def products
    if params[:include_descendants]
      render json: @product_category.self_and_descendants.map(&:products).flatten.uniq
    else
      render json: @product_category.products
    end
  end

  private

    def find_product_category
      @product_category = Category::Product.find(params[:id])
    end
end
