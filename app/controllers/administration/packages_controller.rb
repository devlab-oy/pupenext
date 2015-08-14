class Administration::PackagesController < AdministrationController
  def index
    @packages = Package.all
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
    @package = Package.new
    @package.attributes = package_params

    if @package.save_by current_user
      redirect_to packages_path, notice: t("Pakkaus luotiin onnistuneesti")
    else
      render :edit
    end
  end

  def update
    if @package.update_by(package_params, current_user)
      redirect_to packages_path, notice: t("Pakkaus päivitettiin onnistuneesti")
    else
      render :edit
    end
  end

  def edit_keyword
    @kw = @package.keywords.find(params[:keyword_id])
  end

  def update_keyword
    @package = Package.find(params[:id] || params[:package_id])
    @kw = @package.keywords.find(params[:keyword_id])

    if @kw.update_by(keyword_params, current_user)
      redirect_to package_path(@package.id)
    else
      render :edit_keyword
    end
  end

  def new_keyword
    @kw = @package.keywords.build
  end

  def create_keyword
    @package = Package.find(params[:id] || params[:package_id])
    @kw = @package.keywords.build
    @kw.attributes = keyword_params

    @kw[:yhtio] = @package[:yhtio]
    @kw[:perhe] = @package[:tunnus]
    @kw[:selite] = @package[:tunnus]

    if @kw.save_by current_user
      redirect_to package_path(@package.id)
    else
      render :new_keyword
    end
  end

  def edit_package_code
    @pc = @package.package_codes.find(params[:package_code_id])
  end

  def update_package_code
    @package = Package.find(params[:id] || params[:package_id])
    @pc = @package.package_codes.find(params[:package_code_id])

    if @pc.update_by(package_code_params, current_user)
      redirect_to package_path(@package.id)
    else
      render :edit_package_code
    end
  end

  def new_package_code
    @pc = @package.package_codes.build
  end

  def create_package_code
    @package = Package.find(params[:id] || params[:package_id])
    @pc = @package.package_codes.build
    @pc.attributes = package_code_params

    @pc[:yhtio] = @package[:yhtio]
    @pc[:pakkaus] = @package[:tunnus]

    if @pc.save_by current_user
      redirect_to package_path(@package.id)
    else
      render :new_package_code
    end
  end

private

    def find_resource
      @package = Package.find(params[:id] || params[:package_id])
    end

    def keyword_params
      params.require(:package_keyword).permit(
        :jarjestys,
        :kieli,
        :laji,
        :perhe,
        :selite,
        :selitetark,
      )
    end

    def package_code_params
      params.require(:package_code).permit(
        :koodi,
        :rahdinkuljettaja,
      )
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
      )
    end
end
