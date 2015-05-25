class Administration::PackagesController < AdministrationController
  before_action :find_resource, only: [:show, :edit, :update, :new_keyword, :edit_keyword, :new_package_code, :edit_package_code]
  before_action :find_keyword_languages, only: [:new_keyword, :edit_keyword, :create_keyword, :update_keyword]
  before_action :find_carrier_options, only: [:show, :edit, :new_package_code, :edit_package_code, :create_package_code, :update_package_code]

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

    def find_keyword_languages
      cols = Language.column_names
      @keyword_languages = Hash.new
      cols.each do |col|
        option = Country.where(koodi: col).limit(1).pluck(:nimi)
        option = option.to_s.mb_chars.downcase
        option.sub! '["', ''
        option.sub! '"]', ''
        if col.size == 2
          @keyword_languages[option] = col
        end
      end
    end

    def find_carrier_options
      carriers = Carrier.all
      @carrier_options = Hash.new
      carriers.each do |c|
        @carrier_options[c.koodi] = c.koodi
      end
    end

    def keyword_params
        params.require(:package_keyword).permit(
          :kieli,
          :laji,
          :selite,
          :selitetark,
          :jarjestys,
          :perhe,
          :yhtio
        )
    end

    def package_code_params
        params.require(:package_code).permit(
          :rahdinkuljettaja,
          :koodi,
          :yhtio
        )
    end

    def package_params
        params.require(:package).permit(
          :pakkaus,
          :pakkauskuvaus,
          :pakkausveloitus_tuotenumero,
          :erikoispakkaus,
          :rahtivapaa_veloitus,
          :korkeus,
          :leveys,
          :syvyys,
          :kayttoprosentti,
          :paino,
          :oma_paino,
          :minimi_paino,
          :jarjestys,
          :yksin_eraan,
          :puukotuskerroin
        )
    end
end
