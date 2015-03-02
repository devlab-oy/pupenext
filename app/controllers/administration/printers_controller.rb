class Administration::PrintersController < AdministrationController
  # GET /printers
  def index
    @printers = current_company.printers.search_like(search_params)
  end

  # GET /printers/1
  def show
    render 'edit'
  end

  # GET /printers/new
  def new
    @printer = current_company.printers.build
  end

  # POST /printers
  def create
    @printer = current_company.printers.build(printer_params)

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
    @printer.muuttaja = current_user.kuka

    if @printer.update(printer_params)
      redirect_to printers_path, notice: 'Printer was successfully updated.'
    else
      render action: 'edit'
    end
  end

  private

    def printer_params
      params.require(:printer).permit(:merkisto, :mediatyyppi, :nimi, :komento, :kirjoitin, :ip,
                                      :unifaun_nimi, :osoite, :postino, :postitp, :puhelin,
                                      :yhteyshenkilo, :jarjestys)
    end

    def find_resource
      @printer = current_company.printers.find(params[:id])
    end

    def sortable_columns
      [:kirjoitin, :komento]
    end

    def searchable_columns
      sortable_columns
    end
end
