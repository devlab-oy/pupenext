require 'test_helper'

class FixedAssets::CommoditiesControllerTest < ActionController::TestCase

  setup do
    login users(:joe)
    @commodity = fixed_assets_commodities(:commodity_one)
  end

  test 'should get all commodities' do
    get :index
    assert_response :success

    assert_template "index", "Template should be index"
    assert_not_nil assigns(:commodities)
  end

  test 'should show commodity' do
    request = {id: @commodity.id}

    get :show, request
    assert_response :success

    assert_not_nil assigns(:commodity)
    assert_not_nil assigns(:commodity_rows)
    assert_not_nil assigns(:voucher_rows)
    assert_template "edit", "Template should be edit"
  end

  test 'should show new commodity form' do
    get :new
    assert_response :success

    assert_not_nil assigns(:commodity)
    assert_template 'new', 'Template should be new'
  end

  test 'should get create new commodity' do
    assert_difference('FixedAssets::Commodity.count',1) do
      patch :create, accounting_fixed_assets_commodity: {
            nimitys: 'Chair30000',
            selite: 'Chair for CEO',
            sumu_poistotyyppi: 'B'
      }
      assert_response :found
      assert_equal '', assigns(:commodity).sumu_poistotyyppi

      assert_redirected_to edit_accounting_fixed_assets_commodity_path
    end
  end

  test 'should update commodity' do
    params = {
      nimitys: 'Chair50000',
      selite: 'Chair for CEO',
      sumu_poistotyyppi: 'T',
      sumu_poistoera: 12,
      evl_poistotyyppi: 'P',
      evl_poistoera: 45,
      kayttoonottopvm: Time.now,
      hankintapvm: Time.now,
      tila: 'A'
    }

    patch :update, id: @commodity.id, accounting_fixed_assets_commodity: params

    assert_equal params[:sumu_poistotyyppi], assigns(:commodity).sumu_poistotyyppi

    assert_response :success
    assert_template 'edit', 'Template should be edit'
    assert_equal "Hyödyke päivitettiin onnistuneesti.", flash[:notice]
  end

  test 'should not create new commodity due to permissions' do
    login users(:joe)

    assert_no_difference('Accounting::FixedAssets::Commodity.count') do
      post :create, accounting_fixed_assets_commodity: {
        nimitys: 'Kerrostalo', selite: 'Nooh halvalla sai', summa: 300
      }
    end

    assert_redirected_to accounting_fixed_assets_commodities_path
    assert_equal "Sinulla ei ole päivitysoikeuksia.", flash[:notice]
  end

  test 'should not create new commodity due to params missing' do
    assert_no_difference('FixedAssets::Commodity.count') do
      post :create, accounting_fixed_assets_commodity: {}
    end
    assert_template 'new', 'Template should be new'
  end

  test 'should not update commodity due to params missing' do
    post :patch, accounting_fixed_assets_commodity: {
      nimitys: 'Kissa', selite: '', summa: 300, tila: 'A'
    }
    #reload?
    assert_not_equal 'Kissa', assigns(:commodity).nimitys
    assert_template 'edit', 'Template should be edit'
  end

  test 'should not update commodity due to rights' do
    login users(:joe)

    patch :update, id: @commodity.id, accounting_fixed_assets_commodity: {nimi: ''}

    assert_redirected_to accounting_fixed_assets_commodities_path
    assert_equal "Sinulla ei ole päivitysoikeuksia.", flash[:notice]
  end

  test 'should link commodity cost row' do
    unlinked_row = accounting_rows(:three_accounting_row)
    assert_difference('FixedAssets::CommodityCostRow.count') do
      patch :edit, id: @commodity.id, selected_accounting_row: unlinked_row.id
    end
  end

  test 'should search for specific commodity' do
    skip
    request = {nimitys: 'Mekkonen'}

    get :index, request
    assert_response :success

    assert_template "index", "Template should be index"
  end

  test 'should search for specific voucher' do
    skip
    request = {id: @commodity.id, nimi: 'Acme Corporation Voucher'}

    get 'select_voucher', request
    assert_response :success

    assert_template 'select_voucher', 'Template should be select_voucher'
  end

  test 'should search for specific purchase order' do
    skip
    request = {id: @commodity.id, nimi: 'Acme Corporation PO'}

    get 'select_purchase_order', request
    assert_response :success

    assert_template 'select_purchase_order', 'Template should be select_purchase_order'
  end

  test 'should get fiscal year run' do
    skip
    get :fiscal_year_run
    assert_response :success
  end

  test 'should get link voucher' do
    get :select_voucher, id: @Commodity.id
    assert_response :success
  end

  test 'should update link voucher' do
    params = {}
    patch :select_voucher, params
    assert_response :success
  end

  test 'should get link purchase order' do
    get :select_purchase_order, id: @Commodity.id
    assert_response :success
  end
end
