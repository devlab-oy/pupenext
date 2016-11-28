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
    assert_redirected_to product_stock_pdf_path(1, @hammer, format: :pdf)

    get :find, sku: 'invalid_sku'
    assert_redirected_to product_stock_pdf_index_path(sku: 'invalid_sku')
  end

  test 'renders a pdf' do
    get :show, qty: 1, id: @hammer.tunnus, format: :pdf
    assert_response :success
  end
end
