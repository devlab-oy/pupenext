class Administration::FreightContractsController < AdministrationController
  def index
    @freight_contracts = FreightContract
                           .includes(:customer)
                           .limited
                           .search_like(search_params)
                           .order(order_params)
  end

  private

    def sortable_columns
      [:asiakas, :toimitustapa, :rahtisopimus, :selite]
    end

    def searchable_columns
      sortable_columns
    end
end
