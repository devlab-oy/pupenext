class Administration::CompaniesController < ApplicationController
  skip_before_action :authorize,     :set_current_info, :set_locale, :access_control
  before_action      :api_authorize, :set_current_info, :set_locale, :access_control

  def copy
    company = Company.unscoped.find(params[:id])

    copier = CompanyCopier.new(
      yhtio: company_params[:yhtio],
      company: company,
      company_params: company_params,
    )

    copied_company = copier.copy

    return render json: { company: { id: copied_company.id } } if copied_company.valid?

    render json: { copied_company => copied_company.errors }
  end

  private

    def company_params
      params.require(:company).permit(:yhtio, :nimi, :osoite, :postino, :postitp, :ytunnus)
    end
end
