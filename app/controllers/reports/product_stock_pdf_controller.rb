class Reports::ProductStockPdfController < ApplicationController
  def index
  end

  def find
    product = Product.find_by tuoteno: product_params[:sku]

    if product
      qty = product_params[:qty].blank? ? 1 : product_params[:qty]
      redirect_to product_stock_pdf_path(qty, product.id, format: :pdf)
    else
      notice = t('.product_not_found', sku: product_params[:sku])
      redirect_to product_stock_pdf_index_path(product_params), notice: notice
    end
  end

  def show
    @product = Product.find product_params[:id]
    @qty = params[:qty].to_s

    render :product
  end

  private

    def product_params
      params.permit(:sku, :id, :qty)
    end
end
