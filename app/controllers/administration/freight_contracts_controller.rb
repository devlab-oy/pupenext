class Administration::FreightContractsController < AdministrationController
  def index
    @freight_contracts = FreightContract
                           .with_customer
                           .limited
                           .search_like(search_params)
                           .order(order_params)
  end

  private

    def sortable_columns
      ["asiakas.nimi", :toimitustapa, :rahtisopimus, :selite]
    end

    def searchable_columns
      sortable_columns
    end
end
