class Administration::FreightContractsController < AdministrationController
  def index
    @freight_contracts = FreightContract.ordered.limited
  end
end
