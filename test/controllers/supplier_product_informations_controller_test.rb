require 'test_helper'

class SupplierProductInformationsControllerTest < ActionController::TestCase
  fixtures %i(
    keywords
    product/suppliers
    products
    supplier_product_informations
    suppliers
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

    assert_select 'td', count: 0, text: 'Tramboline'
    assert_select 'td', count: 1, text: 'Chair'
  end

  test 'searching with product id works' do
    get :index, product_id: '2'

    assert_select 'td', count: 1, text: 'Chair'
    assert_select 'td', count: 0, text: 'Tramboline'
  end

  test 'searching with manufacturer part number works' do
    get :index, manufacturer_part_number: '2'

    assert_select 'td', count: 0, text: 'Tramboline'
    assert_select 'td', count: 1, text: 'Chair'
  end

  test 'searching with manufacturer ean works' do
    get :index, manufacturer_ean: '88698592977'

    assert_select 'td', count: 0, text: 'Tramboline'
    assert_select 'td', count: 1, text: 'Chair'
  end

  test 'table containing data is not shown without at least one search criteria submitted' do
    get :index

    assert_select 'table.supplier_product_informations', 0
  end

  test 'only rows which have the selected supplier are shown' do
    get :index, product_name: 'a'

    assert_select 'td', count: 1, text: 'Chair'
    assert_select 'td', count: 0, text: 'Tramboline'
  end

  test 'selected rows are transferred created as products' do
    assert_difference 'Product.count' do
      post :transfer, supplier_product_informations: { "#{@one.id}" => '1' }
    end

    assert_includes     Product.pluck(:tunnus), @one.p_product_id
    assert_not_includes Product.pluck(:tunnus), @two.p_product_id

    assert_equal 'Tuotteet siirretty onnistuneesti järjestelmään', flash[:notice]
  end

  test 'correct fields are copied to product' do
    post :transfer, supplier_product_informations: { "#{@one.id}" => '1' }

    assert_equal @one.manufacturer_part_number, Product.last.tuoteno
    assert_equal @one.product_name,             Product.last.nimitys
    assert_equal 24.to_d,                       Product.last.alv
    assert_equal @one.manufacturer_ean,         Product.last.eankoodi
    assert_equal keywords(:status_active),      Product.last.status
  end

  test 'product suppliers are created for transferred products' do
    assert_difference 'Product::Supplier.count' do
      post :transfer, supplier_product_informations: { "#{@one.id}" => '1' }
    end

    assert_includes     Product::Supplier.pluck(:tuoteno), @one.manufacturer_part_number
    assert_not_includes Product::Supplier.pluck(:tuoteno), @two.manufacturer_part_number
  end

  test 'correct fields are copied to product supplier' do
    post :transfer, supplier_product_informations: { "#{@one.id}" => '1' }

    assert_equal @one.manufacturer_part_number, Product::Supplier.last.tuoteno
    assert_equal @one.product_name,             Product::Supplier.last.toim_nimitys
    assert_equal @one.product_id,               Product::Supplier.last.toim_tuoteno
    assert_equal(-1,                            Product::Supplier.last.osto_alv)
    assert_equal @one.available_quantity,       Product::Supplier.last.tehdas_saldo
    assert_equal @domestic_supplier,            Product::Supplier.last.supplier
  end

  test 'nothing is copied when a product with the same tuoteno exists' do
    @one.update(manufacturer_part_number: products(:hammer).tuoteno)

    assert_no_difference ['Product.count', 'Product::Supplier.count'] do
      post :transfer, supplier_product_informations: { "#{@one.id}" => '1' }
    end
  end

  test 'nothing is copied when a product with the same ean exists' do
    @one.update(manufacturer_ean: products(:hammer).eankoodi)

    assert_no_difference ['Product.count', 'Product::Supplier.count'] do
      post :transfer, supplier_product_informations: { "#{@one.id}" => '1' }
    end
  end

  test 'duplicates are shown on next page' do
    @one.update(manufacturer_ean: products(:hammer).eankoodi)

    post :transfer, supplier_product_informations: { "#{@one.id}" => '1', "#{@two.id}" => '1' }

    assert_response :success

    assert_select 'td', count: 1, text: 'Tramboline'
    assert_select 'td', count: 0, text: 'Chair'

    assert_equal 'Seuraavat rivit löytyvät jo mahdollisesti järjestelmästä ja vaativat tarkastelua',
                 flash[:notice]
  end

  test 'error is shown if no products are selected for transfer' do
    post :transfer

    assert_response :success
    assert_equal 'Et valinnut yhtään riviä', flash[:error]
  end
end
