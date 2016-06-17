class Administration::CompaniesController < ApplicationController
  def copy
    company = Company.unscoped.find(params[:id])

    copier = CompanyCopier.new(
      yhtio: company_params[:yhtio],
      nimi: company_params[:nimi],
      company: company,
    )

    copied_company = copier.copy

    return render json: { company: { id: copied_company.id } } if copied_company.valid?

    render json: { copied_company => copied_company.errors }
  end

  private

    def company_params
      params.require(:company).permit(:yhtio, :nimi)
    end
end
