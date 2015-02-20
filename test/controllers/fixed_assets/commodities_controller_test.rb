require 'test_helper'

class FixedAssets::CommoditiesControllerTest < ActionController::TestCase
  setup do
    login users(:bob)
    @commodity = fixed_assets_commodities(:commodity_one)
  end

  test 'should get all commodities' do
    get :index
    assert_response :success

    assert_not_nil assigns(:commodities)
    assert_template "index", "Template should be index"
  end

  test 'should show commodity' do
    request = { id: @commodity.id }

    get :show, request
    assert_response :success

    assert_not_nil assigns(:commodity)
    assert_template "edit", "Template should be edit"
  end

  test 'should show new commodity form' do
    get :new
    assert_response :success

    assert_not_nil assigns(:commodity)
    assert_template 'new', 'Template should be new'
  end

  test 'should get create new commodity' do
    params = {
      name: 'Chair30000',
      description: 'Chair for CEO',
      planned_depreciation_type: 'B'
    }

    assert_difference('FixedAssets::Commodity.count') do
      patch :create, fixed_assets_commodity: params
    end

    assert_response :found
    assert_nil assigns(:commodity).planned_depreciation_type
    assert_redirected_to edit_commodity_path assigns(:commodity)
  end

  test 'should update commodity' do
    params = {
      name: 'Chair500003',
      description: 'Chair for CEO',
      planned_depreciation_type: 'T',
      planned_depreciation_amount: 12,
      btl_depreciation_type: 'P',
      btl_depreciation_amount: 45,
      activated_at: Time.now,
      purchased_at: Time.now,
      status: ''
    }

    patch :update, id: @commodity.id, fixed_assets_commodity: params

    assert_redirected_to edit_commodity_path assigns(:commodity)
    assert_equal params[:planned_depreciation_type], assigns(:commodity).planned_depreciation_type

    assert_response :found
    assert_equal "Hyödyke päivitettiin onnistuneesti.", flash[:notice]
  end

  test 'should not create new commodity due to permissions' do
    login users(:joe)

    params = {
      name: 'House',
      description: 'Gregory, M.D.'
    }

    assert_no_difference('FixedAssets::Commodity.count') do
      post :create, fixed_assets_commodity: params
    end

    assert_response :forbidden
  end

  test 'should not create new commodity due to params missing' do
    assert_no_difference('FixedAssets::Commodity.count') do
      post :create, fixed_assets_commodity: { name: nil }
    end

    assert_template 'new', 'Template should be new'
  end

  test 'should not update commodity due to params missing' do
    params = {
      name: 'Kissa',
      description: ''
    }

    patch :update, id: @commodity, fixed_assets_commodity: params

    assert_not_equal params[:name], @commodity.reload.name
    assert_template 'edit', 'Template should be edit'
  end

  test 'should not update commodity due to rights' do
    login users(:joe)

    patch :update, id: @commodity.id, fixed_assets_commodity: { nimi: '' }

    assert_response :forbidden
  end

  test 'should get link voucher' do
    get :vouchers, commodity_id: @commodity.id
    assert_response :success
  end

  test 'should update link voucher' do
    params = { commodity_id: @commodity.id }
    post :vouchers, params
    assert_response :success
  end

  test 'should get link purchase order' do
    get :purchase_orders, commodity_id: @commodity.id
    assert_response :success
  end

  test 'should update link purchase order' do
    params = { commodity_id: @commodity.id }
    post :purchase_orders, params
    assert_response :success
  end
end
