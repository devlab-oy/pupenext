class Administration::CompaniesController < ApplicationController
  skip_before_action :authorize,     :set_current_info, :set_locale, :access_control
  before_action      :api_authorize, :set_current_info, :set_locale, :access_control, :find_company

  def copy
    copier = CompanyCopier.new(
      from_company: company,
      to_company_params: company_params,
    )

    copied_company = copier.copy

    return render json: { company: { id: copied_company.id } } if copied_company.valid?

    render json: { copied_company => copied_company.errors }
  end

  def update
    if @company.update(company_params)
      head :no_content
    else
      render json: @company.errors, status: :unprocessable_entity
    end
  end

  private

    def company_params
      params.require(:company).permit(
        :yhtio,
        :nimi,
        :osoite,
        :postino,
        :postitp,
        :ytunnus,
        bank_accounts_attributes: [
          :nimi,
          :oletus_selvittelytili,
          :oletus_kulutili,
          :oletus_rahatili,
          :iban,
          :valkoodi,
          :bic,
        ],
        users_attributes: [
          :kuka,
          :nimi,
          :salasana,
          :extranet,
        ],
      )
    end

    def find_company
      @company = Company.unscoped.find(params[:id])
    end
end
