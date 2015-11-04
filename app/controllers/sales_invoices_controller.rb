class SalesInvoicesController < ApplicationController
  before_action :set_sales_invoice, only: [:show]

  def show
    respond_to do |format|
      format.xml do
        @finvoice = Finvoice.new invoice_id: @sales_invoice.id
        render :finvoice
      end
    end
  end

  private

    def set_sales_invoice
      @sales_invoice = Head::SalesInvoice.find params[:id]
    end
end
