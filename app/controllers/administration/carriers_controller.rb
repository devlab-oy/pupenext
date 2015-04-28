class Administration::CarriersController < AdministrationController
  def index
    @carriers = current_company.carriers.search_like(search_params).order(order_params)
  end

  def show
    render :edit
  end

  def edit
  end

  def new
    @carrier = current_company.carriers.build
  end

  private

    def carrier_params
      params.require(:carrier).permit(
        :koodi,
        :nimi,
        :jalleenmyyjanro,
        :neutraali,
        :pakkauksen_sarman_minimimitta
      )
    end

    def find_resource
      @carrier = current_company.carriers.find(params[:id])
    end

    def searchable_columns
      [
        :koodi,
        :nimi,
        :jalleenmyyjanro,
        :neutraali,
        :pakkauksen_sarman_minimimitta
      ]
    end

    def sortable_columns
      searchable_columns
    end
end
