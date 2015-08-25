class Administration::DeliveryMethodsController < AdministrationController
  def index
    @delivery_methods = DeliveryMethod.search_like(search_params).order(order_params)
  end

  private
    def delivery_method_params
      params.require(:delivery_method).permit(
        :selite,
        :tulostustapa,
        :sopimusnro,
        :nouto,
        :ei_pakkaamoa,
        :extranet,
        :rahtikirja,
        :jarjestys,
      )
    end

    def searchable_columns
      [
        :selite,
        :tulostustapa,
        :sopimusnro,
        :nouto,
        :ei_pakkaamoa,
        :extranet,
        :rahtikirja,
        :jarjestys,
      ]
    end

    def find_resource
      @delivery_method = DeliveryMethod.find params[:id]
    end

    def sortable_columns
      searchable_columns
    end
end
