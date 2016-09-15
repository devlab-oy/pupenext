class Administration::UsersController < AdministrationController
  def index
    @users = User.search_like(search_params).order(order_params)
  end

  def new
    @user = User.new
    render :edit
  end

  def show
    render :edit
  end

  def create
    @user = User.new user_params

    if @user.save
      redirect_to users_path, notice: t('.create_success')
    else
      render :edit
    end
  end

  def edit
  end

  def update
    if @user.update user_params
      redirect_to users_path, notice: t('.update_success')
    else
      render :edit
    end
  end

  def destroy
    @user.destroy

    redirect_to users_path, notice: t('.destroy_success')
  end

  private

    def find_resource
      @user = User.find params[:id]
    end

    def user_params
      params.require(:user).permit(
        :aktiivinen,
        :asema,
        :budjetti,
        :dynaaminen_kassamyynti,
        :eilahetetta,
        :eposti,
        :fyysinen_sijainti,
        :hierarkia,
        :hinnat,
        :hyvaksyja,
        :hyvaksyja_maksimisumma,
        :ip,
        :jyvitys,
        :kassalipas_otto,
        :kassamyyja,
        :kayttoliittyma,
        :keraajanro,
        :keraysvyohyke,
        :kieli,
        :kirjoitin,
        :kuittitulostin,
        :kuka,
        :kulujen_laskeminen_hintoihin,
        :lahetetulostin,
        :lomaoikeus,
        :maksuehto,
        :maksupaate_ip,
        :maksupaate_kassamyynti,
        :max_keraysera_alustat,
        :mitatoi_tilauksia,
        :myyja,
        :myyjaryhma,
        :naytetaan_asiakashinta,
        :naytetaan_katteet_tilauksella,
        :naytetaan_tilaukset,
        :naytetaan_tuotteet,
        :nimi,
        :oletus_asiakas,
        :oletus_asiakastiedot,
        :oletus_ohjelma,
        :oletus_ostovarasto,
        :oletus_pakkaamo,
        :oletus_profiili,
        :oletus_varasto,
        :osasto,
        :piirit,
        :profiilit,
        :puhno,
        :rahtikirjatulostin,
        :saatavat,
        :salasana,
        :taso,
        :tilaus_valmis,
        :toimipaikka,
        :toimitustapa,
        :tuuraaja,
        :varasto,
      )
    end

    def searchable_columns
      [
        :nimi,
        :kuka,
        :eposti,
      ]
    end

    def sortable_columns
      searchable_columns
    end
end
