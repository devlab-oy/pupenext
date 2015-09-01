class Administration::BankDetailsController < AdministrationController
  def index
    @bank_details = BankDetail.all.order :nimitys
  end

  def create
    @bank_detail = BankDetail.new bank_detail_attributes

    if @bank_detail.save
      redirect_to bank_details_url
    else
      render :edit
    end
  end

  def update
    if @bank_detail.update bank_detail_attributes
      redirect_to bank_details_url
    else
      render :edit
    end
  end

  def new
    @bank_detail = BankDetail.new
    render :edit
  end

  private

    def bank_detail_attributes
      params.require(:bank_detail).permit(resource_parameters(BankDetail,
        :nimitys,
        :pankkiiban1,
        :pankkiiban2,
        :pankkiiban3,
        :pankkinimi1,
        :pankkinimi2,
        :pankkinimi3,
        :pankkiswift1,
        :pankkiswift2,
        :pankkiswift3,
        :pankkitili1,
        :pankkitili2,
        :pankkitili3,
        :viite,
      ))
    end

    def find_resource
      @bank_detail = BankDetail.find params[:id]
    end
end
