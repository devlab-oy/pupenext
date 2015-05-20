class Administration::PrintersController < AdministrationController
  # GET /printers
  def index
    @printers = Printer
      .search_like(search_params)
      .order(order_params)
  end

  # GET /printers/1
  def show
    render :edit
  end

  # GET /printers/new
  def new
    @printer = Printer.new
  end

  # POST /printers
  def create
    @printer = Printer.new(printer_params)

    if @printer.save_by current_user
      redirect_to printers_path, notice: "Kirjoitin luotiin onnistuneesti"
    else
      render :new
    end
  end

  # GET /printers/1/edit
  def edit
  end

  # PATCH/PUT /printers/1
  def update
    if @printer.update_by(printer_params, current_user)
      redirect_to printers_path, notice: "Kirjoitin päivitettiin onnistuneesti"
    else
      render :edit
    end
  end

  def destroy
    @printer.destroy
    redirect_to printers_path, notice: "Kirjoitin poistettiin onnistuneesti"
  end

  private

    def printer_params
      params.require(:printer).permit(
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
        :jarjestys
      )
    end

    def find_resource
      @printer = Printer.find(params[:id])
    end

    def sortable_columns
      [:kirjoitin, :komento]
    end

    def searchable_columns
      sortable_columns
    end
end
