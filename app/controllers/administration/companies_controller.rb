class Administration::CompaniesController < ApplicationController
  protect_from_forgery with: :null_session

  skip_before_action :authorize,     :set_current_info, :set_locale, :access_control
  before_action      :api_authorize, :set_current_info, :set_locale, :access_control

  def copy
    copier = CompanyCopier.new(
      from_company: Current.company,
      to_company_params: company_params,
      customer_companies: params[:customer_companies],
      supplier_companies: params[:supplier_companies],
    )

    copier.copy

    if copier.errors.empty?
      render json: { company: { id: copier.copied_company.id } }
    else
      render json: { errors: copier.errors }, status: :unprocessable_entity
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
        :jarjestys,
        :email,
        :tilikausi_alku,
        :tilikausi_loppu,
        :ostoreskontrakausi_alku,
        :ostoreskontrakausi_loppu,
        :myyntireskontrakausi_alku,
        :myyntireskontrakausi_loppu,
        :ovttunnus,
        :pankkinimi1,
        :pankkitili1,
        bank_accounts_attributes: [
          :nimi,
          :tilino,
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
          :profiilit,
          :extranet,
          :oletus_asiakas,
          :oletus_asiakastiedot,
          :oletus_profiili,
          :kieli,
          :eposti,
          :tilaus_valmis,
          :aktiivinen,
        ],
      )
    end
end
