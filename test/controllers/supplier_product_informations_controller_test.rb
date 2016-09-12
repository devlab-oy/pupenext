require 'test_helper'

class SupplierProductInformationsControllerTest < ActionController::TestCase
  fixtures %i(
    category/links
    category/products
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

    @category_tools    = keywords(:category_tools)
    @subcategory_tools = keywords(:subcategory_tools)
    @brand_tools       = keywords(:brand_tools)

    @dynamic_tree_one = category_products(:product_category_shirts)

    session[:supplier] = @domestic_supplier.id

    @params = {
      supplier_product_informations: {
        "#{@one.id}" => {
          transfer:    1,
          osasto:      @category_tools.id,
          try:         @subcategory_tools.id,
          tuotemerkki: @brand_tools.id,
          p_tree_id:   @dynamic_tree_one,
          nakyvyys:    'Y',
          status:      'A'
        }
      }
    }
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

  test 'filtering with manufacturer works' do
    get :index, manufacturer_name: '@Manufacturer 2'

    assert_select 'td', count: 0, text: 'Tramboline'
    assert_select 'td', count: 1, text: 'Chair'
  end

  test 'searching with product name works' do
    get :index, product_name: 'ch'

    assert_select 'td', count: 0, text: 'Tramboline'
    assert_select 'td', count: 1, text: 'Chair'
  end

  test 'searching with category text works' do
    get :index, category_text1: 'MyString1'

    assert_select 'td', count: 0, text: 'Tramboline'
    assert_select 'td', count: 1, text: 'Chair'

    get :index, category_text2: 'MyString2'

    assert_select 'td', count: 0, text: 'Tramboline'
    assert_select 'td', count: 1, text: 'Chair'

    get :index, category_text3: 'MyString3'

    assert_select 'td', count: 0, text: 'Tramboline'
    assert_select 'td', count: 1, text: 'Chair'

    get :index, category_text4: 'MyString4'

    assert_select 'td', count: 0, text: 'Tramboline'
    assert_select 'td', count: 1, text: 'Chair'
  end

  test 'searching with description works' do
    get :index, description: 'MyString'

    assert_select 'td', count: 1, text: 'Chair'
    assert_select 'td', count: 0, text: 'Tramboline'
  end

  test 'searching with supplier part number works' do
    get :index, supplier_part_number: 'MySupplierPartNumber'

    assert_select 'td', count: 1, text: 'Chair'
    assert_select 'td', count: 0, text: 'Tramboline'
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
      post :transfer, @params
    end

    assert_includes     Product.pluck(:tunnus), @one.p_product_id
    assert_not_includes Product.pluck(:tunnus), @two.p_product_id

    assert_equal 'Tuotteet siirretty onnistuneesti järjestelmään', flash[:notice]
  end

  test 'correct fields are updated' do
    @params[:supplier_product_informations]["#{@one.id}"][:toimittajan_ostohinta] = '1'
    @params[:supplier_product_informations]["#{@one.id}"][:toimittajan_saldo] = '1'
    @params[:supplier_product_informations]["#{@one.id}"][:p_tree_id] = @dynamic_tree_one.id

    post :transfer, @params

    assert_equal 1, @one.reload.p_price_update
    assert_equal 1, @one.reload.p_qty_update
    assert_equal Product.last, @one.reload.product
    assert_equal @dynamic_tree_one, @one.reload.product_category
  end

  test 'correct fields are copied to product' do
    post :transfer, @params

    assert_equal @one.manufacturer_part_number, Product.last.tuoteno
    assert_equal @one.product_name,             Product.last.nimitys
    assert_equal 24.to_d,                       Product.last.alv
    assert_equal @one.manufacturer_ean,         Product.last.eankoodi
    assert_equal 'A',                           Product.last.status
    assert_equal @category_tools,               Product.last.category
    assert_equal @subcategory_tools,            Product.last.subcategory
    assert_equal @brand_tools,                  Product.last.brand
    assert_equal 'Y',                           Product.last.nakyvyys
  end

  test 'product suppliers are created for transferred products' do
    assert_difference 'Product::Supplier.count' do
      post :transfer, @params
    end

    assert_includes     Product::Supplier.pluck(:tuoteno), @one.manufacturer_part_number
    assert_not_includes Product::Supplier.pluck(:tuoteno), @two.manufacturer_part_number
  end

  test 'correct fields are copied to product supplier' do
    post :transfer, @params

    assert_equal @one.manufacturer_part_number, Product::Supplier.last.tuoteno
    assert_equal @one.product_name,             Product::Supplier.last.toim_nimitys
    assert_equal @one.product_id,               Product::Supplier.last.toim_tuoteno
    assert_equal(-1,                            Product::Supplier.last.osto_alv)
    assert_equal @one.available_quantity,       Product::Supplier.last.tehdas_saldo
    assert_equal @domestic_supplier,            Product::Supplier.last.supplier
  end

  test 'dynamic tree product node is created correctly' do
    assert_difference('Category::ProductLink.count') do
      post :transfer, @params
    end
  end

  test 'nothing is copied when a product with the same tuoteno exists' do
    @one.update(manufacturer_part_number: products(:hammer).tuoteno)

    assert_no_difference %w(Product.count Product::Supplier.count) do
      post :transfer, @params
    end
  end

  test 'nothing is copied when a product with the same ean exists' do
    @one.update(manufacturer_ean: products(:hammer).eankoodi)

    assert_no_difference %w(Product.count Product::Supplier.count) do
      post :transfer, @params
    end
  end

  test 'duplicates are shown on next page' do
    @one.update(manufacturer_ean: products(:hammer).eankoodi)

    params = @params.merge("#{@two.id}" => { transfer: 1 })

    post :transfer, params

    assert_response :success

    assert_select 'td', count: 1, text: 'Tramboline'
    assert_select 'td', count: 0, text: 'Chair'

    assert_equal 'Seuraavat rivit löytyvät jo mahdollisesti järjestelmästä ja vaativat tarkastelua',
                 flash[:notice]
  end

  test 'manufacturer part number can be changed if its already found in the system' do
    @one.update(manufacturer_part_number: products(:hammer).tuoteno)

    post :transfer, @params

    assert_select "input[name='supplier_product_informations[#{@one.id}][manufacturer_part_number]']"
    assert_select "input[name='supplier_product_informations[#{@one.id}][manufacturer_ean]']", count: 0
  end

  test 'manufacturer part number is taken from params if given' do
    @params[:supplier_product_informations]["#{@one.id}"][:manufacturer_part_number] = 987654321

    post :transfer, @params

    assert_equal '987654321', Product.last.tuoteno
    assert_equal '987654321', Product::Supplier.last.tuoteno
  end

  test 'error is shown if no products are selected for transfer and search is preserved' do
    post :transfer, product_name: 'ch'

    assert_redirected_to supplier_product_informations_url(product_name: 'ch')
    assert_equal 'Et valinnut yhtään riviä', flash[:alert]
  end

  test 'doesnt crash if extra attributes are not specified' do
    post :transfer, supplier_product_informations: { "#{@one.id}" => { transfer: 1 } }

    assert_redirected_to supplier_product_informations_url
  end
end
