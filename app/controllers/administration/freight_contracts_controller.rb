class Administration::FreightContractsController < AdministrationController
  def index
    @freight_contracts = FreightContract
                           .with_customer
                           .search_like(search_params)
                           .order(order_params)

    unless params[:limit] == "off"
      @freight_contracts = @freight_contracts.limit(350)
    end
  end

  private

    def sortable_columns
      ["asiakas.nimi", :ytunnus, :toimitustapa, :rahtisopimus, :selite]
    end

    def searchable_columns
      sortable_columns
    end
end
