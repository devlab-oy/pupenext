class Administration::DeliveryMethodsController < AdministrationController
  def index
    @delivery_methods = DeliveryMethod.search_like(search_params).order(order_params)
  end

  def show
    render :edit
  end

  def edit
  end

  def new
    @delivery_method = DeliveryMethod.new
    render :edit
  end

  def create
    @delivery_method = DeliveryMethod.new delivery_method_params

    if @delivery_method.save
      redirect_to delivery_methods_path, notice: t('.create_success')
    else
      render :edit
    end
  end

  def update
    if @delivery_method.update delivery_method_params
      redirect_to delivery_methods_path, notice: t('.update_success')
    else
      render :edit
    end
  end

  def destroy
    if @delivery_method.destroy
      redirect_to delivery_methods_path, notice: t('.destroy_success')
    else
      render :edit
    end
  end

  private
    def delivery_method_params
      params.require(:delivery_method).permit(
        :aktiivinen_kuljetus, :aktiivinen_kuljetus_kansallisuus, :ei_pakkaamoa,
        :erikoispakkaus_kielto, :erilliskasiteltavakulu, :erittely, :extranet,
        :jarjestys, :jvkielto, :jvkulu, :kauppatapahtuman_luonne, :kontti,
        :kuljetusmuoto, :kuljetusvakuutus, :kuljetusvakuutus_tuotenumero,
        :kuljetusvakuutus_tyyppi, :kuljyksikko, :kuluprosentti, :lahdon_selite,
        :lajittelupiste, :lauantai, :lisakulu, :lisakulu_summa, :logy_rahtikirjanumerot,
        :maa_maara, :merahti, :nouto, :osoitelappu, :poistumistoimipaikka_koodi,
        :rahdinkuljettaja, :rahti_tuotenumero, :rahtikirja, :rahtikirjakopio_email,
        :sallitut_alustat, :sallitut_maat, :selite, :sisamaan_kuljetus,
        :sisamaan_kuljetus_kansallisuus, :sisamaan_kuljetusmuoto, :sopimusnro,
        :toim_maa, :toim_nimi, :toim_nimitark, :toim_osoite, :toim_ovttunnus,
        :toim_postino, :toim_postitp, :tulostustapa, :ulkomaanlisa, :uudet_pakkaustiedot,
        :vaihtoehtoinen_vak_toimitustapa, :vak_kielto, :virallinen_selite,
      )
    end

    def searchable_columns
      [
        :selite,
        :sopimusnro,
        :jarjestys,
      ]
    end

    def find_resource
      @delivery_method = DeliveryMethod.find params[:id]
    end

    def sortable_columns
      searchable_columns
    end
end
