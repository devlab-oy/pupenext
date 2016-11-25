class Reports::ProductStockPdfController < ApplicationController
  def index
  end

  def find
    product = Product.find_by tuoteno: product_params[:sku]

    if product
      redirect_to product_stock_pdf_path(product.id, format: :pdf)
    else
      notice = t('.product_not_found', sku: product_params[:sku])
      redirect_to product_stock_pdf_index_path, notice: notice
    end
  end

  def show
    @product = Product.find product_params[:id]
    @kpl = params[:kpl].to_s

    render :product
  end

  private

    def product_params
      params.permit(:sku, :id, :kpl)
    end
end
