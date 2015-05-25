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

  def create
    @freight_contract = FreightContract.new(freight_contract_params)

    if @freight_contract.save_by(current_user)
      redirect_to freight_contracts_url
    else
      render :new
    end
  end

  def new
    @freight_contract = FreightContract.new
  end

  private

    def sortable_columns
      ["asiakas.nimi", :ytunnus, :toimitustapa, :rahtisopimus, :selite]
    end

    def searchable_columns
      sortable_columns
    end

    def freight_contract_params
      params.require(:freight_contract).permit(:toimitustapa,
                                               :asiakas,
                                               :ytunnus,
                                               :rahtisopimus,
                                               :selite,
                                               :muumaksaja)
    end
end
