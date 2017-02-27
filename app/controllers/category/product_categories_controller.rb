class Category::ProductCategoriesController < CategoriesController
  before_action :find_product_category, only: [:show, :children, :products, :breadcrumbs]

  def index
    categories = Category.all
    categories = categories.find(params[:ids]) if params[:ids]

    render json: categories
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
    _products = params[:pupeshop].present? ? @product_category.products.webstore_visible() : @product_category.products

    if params[:include_descendants]
      render json: @product_category.self_and_descendants.map(TÄHÄ JOTTAI KIKKAA: &:products).flatten.uniq
    else
      render json: _products
    end
  end

  def breadcrumbs
    render json: @product_category.self_and_ancestors.map { |c| { c.id => c.nimi } }
  end

  private

    def find_product_category
      @product_category = Category::Product.find(params[:id])
    end
end
