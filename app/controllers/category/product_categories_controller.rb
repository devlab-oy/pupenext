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
    if params[:pupeshop].present?
      render json: @product_category.products.not_deleted()
    elsif params[:include_descendants]
      render json: @product_category.self_and_descendants.map(&:products).flatten.uniq
    else
      render json: @product_category.products
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
