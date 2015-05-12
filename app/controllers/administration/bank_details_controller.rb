class Administration::BankDetailsController < AdministrationController
  def index
    @bank_details = current_company.bank_details
  end

  def create
    @bank_detail = current_company.bank_details.build(bank_detail_attributes)

    if @bank_detail.save_by current_user
      redirect_to bank_details_url
    else
      render :new
    end
  end

  def update
    if @bank_detail.update_by(bank_detail_attributes, current_user)
      redirect_to bank_details_url
    else
      render :edit
    end
  end

  private

    def bank_detail_attributes
      params
        .require(:bank_detail)
        .permit(:nimitys, :pankkinimi1, :pankkitili1, :pankkiiban1, :pankkiswift1, :pankkinimi2,
                :pankkitili2, :pankkiiban2, :pankkiswift2, :pankkinimi3, :pankkitili3, :pankkiiban3,
                :pankkiswift3, :viite)
    end

    def find_resource
      @bank_detail = current_company.bank_details.find(params[:id])
    end

    def sortable_columns
      [:nimitys]
    end

    def searchable_columns
      sortable_columns
    end
end
