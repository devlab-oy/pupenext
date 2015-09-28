class Administration::TransportsController < AdministrationController
  def index
    @transports = Transport.all
  end

  def show
    render :edit
  end

  def new
    @transport = Transport.new
    render :edit
  end

  def edit
  end

  def create
    @transport = Transport.new(transport_params)

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
      @transport = Transport.find(params[:id])
    end

    def transport_params
      params.require(:transport).permit(
        :customer_id,
        :hostname,
        :password,
        :path,
        :username,
      )
    end
end
