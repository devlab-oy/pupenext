require 'test_helper'

class SupplierProductInformationsControllerTest < ActionController::TestCase
  fixtures %i(
    suppliers
    supplier_product_informations
  )

  setup do
    login users(:bob)

    @domestic_supplier = suppliers(:domestic_supplier)

    session[:supplier] = @domestic_supplier.id
  end

  test 'supplier has to be selected first' do
    session[:supplier] = nil

    get :index

    assert_response :success

    assert_select 'select[name=supplier]'
    assert_select 'table.supplier_product_informations', { count: 0 }
    assert_select 'table.search-fields', { count: 0 }
  end

  test 'supplier selection works' do
    session[:supplier] = nil

    get :index, supplier: @domestic_supplier.id

    assert_response :success
    assert_equal @domestic_supplier.id.to_s, session[:supplier]

    assert_select 'select[name=supplier]'
    assert_select 'table.supplier_product_informations'
  end

  test 'searching with product name works' do
    get :index, product_name: 'amb'

    assert_select 'td', { count: 1, text: 'Tramboline' }
    assert_select 'td', { count: 0, text: 'Chair' }
  end

  test 'searching with product id works' do
    get :index, product_id: '2'

    assert_select 'td', { count: 1, text: 'Chair' }
    assert_select 'td', { count: 0, text: 'Tramboline' }
  end

  test 'searching with manufacturer part number works' do
    get :index, manufacturer_part_number: '1'

    assert_select 'td', { count: 1, text: 'Tramboline' }
    assert_select 'td', { count: 0, text: 'Chair' }
  end

  test 'searching with manufacturer ean works' do
    get :index, manufacturer_ean: '10343600935'

    assert_select 'td', { count: 1, text: 'Tramboline' }
    assert_select 'td', { count: 0, text: 'Chair' }
  end
end
