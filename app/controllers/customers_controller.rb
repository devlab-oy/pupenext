class CustomersController < ApplicationController
  skip_before_filter :authorize

  def create
    @customer = current_company.customers.build(customer_params)

    if @customer.save
      render json: { status: :created }, status: :created
    else
      render json: { error: "Not created", status: :unprocessable_entity }
    end
  end

  def update
    @customer = current_company.customers.find(params[:id])
    if @customer.update(customer_params)
      render json: { status: :ok }
    else
      render json: { error: "Not created", status: :unprocessable_entity }
    end
  end

  def find_by_email
    if customer = Customer.find_by_email(find_by_params[:email])
      render json: customer
    else
      render json: { error: "Not found", status: :not_found }
    end
  end

  private

    def customer_params
      params.require(:customer).permit(
        :ytunnus,
        :asiakasnro,
        :nimi,
        :nimitark,
        :osoite,
        :postino,
        :postitp,
        :maa,
        :toim_maa,
        :email,
        :puhelin
      )
    end

    def find_by_params
      params.permit(:email)
    end
end
