class Administration::PackagesController < AdministrationController
  def index
    @packages = Package.search_like(search_params).order(order_params)
  end

  def show
    render :edit
  end

  def edit
  end

  def new
    @package = Package.new
    render :edit
  end

  def create
    @package = Package.new package_params

    if @package.save
      redirect_to packages_path, notice: t('.create_success')
    else
      render :edit
    end
  end

  def update
    if @package.update package_params
      redirect_to packages_path, notice: t('.update_success')
    else
      render :edit
    end
  end

  def destroy
    @package.destroy!

    redirect_to packages_url
  end

  private

    def find_resource
      @package = Package.find params[:id]
    end

    def package_params
      params.require(:package).permit(
        :erikoispakkaus,
        :jarjestys,
        :kayttoprosentti,
        :korkeus,
        :leveys,
        :minimi_paino,
        :oma_paino,
        :paino,
        :pakkaus,
        :pakkauskuvaus,
        :pakkausveloitus_tuotenumero,
        :puukotuskerroin,
        :rahtivapaa_veloitus,
        :syvyys,
        :yksin_eraan,
        translations_attributes: [ :id, :kieli, :selitetark, :_destroy ],
        package_codes_attributes: [ :id, :pakkaus, :rahdinkuljettaja, :koodi, :_destroy ],
      )
    end

    def sortable_columns
      [
        :jarjestys,
        :korkeus,
        :leveys,
        :paino,
        :pakkaus,
        :pakkauskuvaus,
        :syvyys,
      ]
    end

    def searchable_columns
      sortable_columns
    end
end
