class Administration::TransportsController < AdministrationController
  def index
    @transports = current_company.transports
  end

  def show
    render :edit
  end

  def new
    @transport = current_company.transports.new
    render :edit
  end

  def edit
  end

  def create
    @transport = current_company.transports.new transport_params

    if @transport.save
      redirect_to transports_url
    else
      render :edit
    end
  end

  def update
    if @transport.update(transport_params)
      redirect_to transports_url
    else
      render :edit
    end
  end

  def destroy
    @transport.destroy
    redirect_to transports_url
  end

  private

    def find_resource
      @transport = current_company.transports.find params[:id]
    end

    def transport_params
      params.require(:transport).permit(
        :transport_name,
        :encoding,
        :filename,
        :hostname,
        :password,
        :path,
        :port,
        :transportable_id,
        :username,
      )
    end
end
