class Administration::ProductsController < AdministrationController
  before_action :find_resource, only: [:update]

  def update
    if @product.update! product_params
      head :success
    else
      head :unprocessable_entity
    end
  end

  private

    def find_resource
      @product = Product.find params[:id]
    end

    def product_params
      params.require(:product).permit(
        pending_updates_attributes: [ :key, :value_type, :value ],
      )
    end
end
