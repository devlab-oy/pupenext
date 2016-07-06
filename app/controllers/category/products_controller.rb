class Category::ProductsController < CategoriesController
  def index
    render json: Category::Product.roots
  end
end
