require 'test_helper'
class Accounting::FixedAssets::CommoditiesControllerTest < ActionController::TestCase

  def setup
    cookies[:pupesoft_session] = users(:joe).session
  end

  test 'should get all commodities' do
    get :index
    assert_response :success

    assert_template "index", "Template should be index"
  end

  test 'should show commodity' do
    commodity = accounting_fixed_assets_commodities(:one)
    request = {id: commodity.id}

    get :show, request
    assert_response :success

    assert_template "edit", "Template should be edit"
  end

  test 'should show new commodity form' do
    get :new
    assert_response :success

    assert_template 'new', 'Template should be new'
  end

  test 'should create new commodity' do
    assert_difference('Accounting::FixedAssets::Commodity.count') do
      post :create, accounting_fixed_assets_commodity: {
        nimitys: 'Skoda123',
        selite: 'Auto Pentille',
        summa: 3000
      }
    end

    assert_redirected_to accounting_fixed_assets_commodities_path
    assert_equal "Hyödyke luotiin onnistuneesti.", flash[:notice]
  end

  test 'should not create new commodity' do
    # User bob does not have permission to create
    cookies[:pupesoft_session] = users(:bob).session

    assert_no_difference('Accounting::FixedAssets::Commodity.count') do
      post :create, accounting_fixed_assets_commodity: {
        nimitys: 'Kerrostalo', selite: 'Nooh halvalla sai', summa: 300
      }
    end

    assert_redirected_to accounting_fixed_assets_commodities_path
    assert_equal "Sinulla ei ole päivitysoikeuksia.", flash[:notice]
  end

  test 'should update commodity' do
    commodity = accounting_fixed_assets_commodities(:one)

    patch :update, id: commodity.id, accounting_fixed_assets_commodity: {
      nimitys: ''
    }

    assert_redirected_to accounting_fixed_assets_commodities_path
    assert_equal "Hyödyke päivitettiin onnistuneesti.", flash[:notice]
  end

  test 'should not update commodity' do
    cookies[:pupesoft_session] = users(:bob).session
    commodity = accounting_fixed_assets_commodities(:one)

    patch :update, id: commodity.id, accounting_fixed_assets_commodity: {nimi: ''}

    assert_redirected_to accounting_fixed_assets_commodities_path
    assert_equal "Sinulla ei ole päivitysoikeuksia.", flash[:notice]
  end

end
