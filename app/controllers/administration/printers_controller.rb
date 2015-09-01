class Administration::PrintersController < AdministrationController
  def index
    @printers = Printer
      .search_like(search_params)
      .order(order_params)
  end

  def show
    render :edit
  end

  def new
    @printer = Printer.new
    render :edit
  end

  def create
    @printer = Printer.new printer_params

    if @printer.save
      redirect_to printers_path, notice: t('.create_success')
    else
      render :edit
    end
  end

  def edit
  end

  def update
    if @printer.update printer_params
      redirect_to printers_path, notice: t('.update_success')
    else
      render :edit
    end
  end

  def destroy
    @printer.destroy
    redirect_to printers_path, notice: t('.destroy_success')
  end

  private

    def printer_params
      resource_parameters model: :printer, parameters: [
        :merkisto,
        :mediatyyppi,
        :nimi,
        :komento,
        :kirjoitin,
        :ip,
        :unifaun_nimi,
        :osoite,
        :postino,
        :postitp,
        :puhelin,
        :yhteyshenkilo,
        :jarjestys,
      ]
    end

    def find_resource
      @printer = Printer.find params[:id]
    end

    def sortable_columns
      [:kirjoitin, :komento]
    end

    def searchable_columns
      sortable_columns
    end
end
