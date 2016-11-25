require 'test_helper'

class Reports::ProductStockPdfControllerTest < ActionController::TestCase
  fixtures %w(
    products
    shelf_locations
  )

  setup do
    login users :bob

    @hammer = products :hammer
  end

  test 'get report index and report selection' do
    get :index
    assert_response :success
  end

  test 'finds a product' do
    get :find, sku: @hammer.tuoteno
    assert_redirected_to product_stock_pdf_path(@hammer, format: :pdf)

    get :find, sku: 'invalid_sku'
    assert_redirected_to product_stock_pdf_index_path
  end

  test 'renders a pdf' do
    get :show, id: @hammer.tunnus, format: :pdf
    assert_response :success
  end
end
