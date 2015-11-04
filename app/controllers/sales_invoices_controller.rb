class SalesInvoicesController < ApplicationController
  before_action :set_sales_invoice, only: [:show]

  def show
    respond_to do |format|
      format.xml { render :finvoice }
    end
  end

  private

    def set_sales_invoice
      @sales_invoice = Head::SalesInvoice.find params[:id]
    end
end
