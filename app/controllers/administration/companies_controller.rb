class Administration::CompaniesController < ApplicationController
  def copy
    company = Company.unscoped.find(params[:id])

    copier = CompanyCopier.new(
      yhtio: company_params[:yhtio],
      nimi: company_params[:nimi],
      company: company,
    )

    copied_company = copier.copy

    render json: { company: { id: copied_company.id } }
  end

  private

    def company_params
      params.require(:company).permit(:yhtio, :nimi)
    end
end
