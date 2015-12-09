require 'test_helper'

class SupplierProductInformationsControllerTest < ActionController::TestCase
  fixtures %i(
    products
    suppliers
    supplier_product_informations
  )

  setup do
    login users(:bob)

    @one = supplier_product_informations(:one)
    @two = supplier_product_informations(:two)

    @domestic_supplier = suppliers(:domestic_supplier)

    session[:supplier] = @domestic_supplier.id
  end

  test 'supplier has to be selected first' do
    session[:supplier] = nil

    get :index

    assert_response :success

    assert_select 'select[name=supplier]'
    assert_select 'table.supplier_product_informations', 0
    assert_select 'table.search-fields', 0
  end

  test 'supplier selection works' do
    session[:supplier] = nil

    get :index, supplier: @domestic_supplier.id, product_name: 'a'

    assert_response :success
    assert_equal @domestic_supplier.id.to_s, session[:supplier]

    assert_select 'select[name=supplier]'
    assert_select 'table.supplier_product_informations'
  end

  test 'searching with product name works' do
    get :index, product_name: 'ch'

    assert_select 'td', { count: 0, text: 'Tramboline' }
    assert_select 'td', { count: 1, text: 'Chair' }
  end

  test 'searching with product id works' do
    get :index, product_id: '2'

    assert_select 'td', { count: 1, text: 'Chair' }
    assert_select 'td', { count: 0, text: 'Tramboline' }
  end

  test 'searching with manufacturer part number works' do
    get :index, manufacturer_part_number: '2'

    assert_select 'td', { count: 0, text: 'Tramboline' }
    assert_select 'td', { count: 1, text: 'Chair' }
  end

  test 'searching with manufacturer ean works' do
    get :index, manufacturer_ean: '88698592977'

    assert_select 'td', { count: 0, text: 'Tramboline' }
    assert_select 'td', { count: 1, text: 'Chair' }
  end

  test 'table containing data is not shown without at least one search criteria submitted' do
    get :index

    assert_select 'table.supplier_product_informations', 0
  end

  test 'only rows which have the selected supplier are shown' do
    get :index, product_name: 'a'

    assert_select 'td', { count: 1, text: 'Chair' }
    assert_select 'td', { count: 0, text: 'Tramboline' }
  end

  test 'selected rows are transferred created as products' do
    assert_difference 'Product.count' do
      post :transfer, supplier_product_informations: { "#{@one.id}" => '1' }
    end
  end
end
