class CustomersController < ApplicationController
  skip_before_filter :authorize

  def create
  end

  def update
  end

  def find_by_email
    if customer = Customer.find_by_email(find_by_params[:email])
      render json: customer
    else
      render json: { error: "not found", status: 404 }
    end
  end

  private

    def find_by_params
      params.permit(:email)
    end
end
