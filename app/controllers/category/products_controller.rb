class Category::ProductsController < CategoriesController
  def index
    render json: Category::Product.roots
  end

  def tree
    render json: Category::Product.tree
  end
end
