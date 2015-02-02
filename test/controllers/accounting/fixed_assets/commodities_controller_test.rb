require 'test_helper'

class Accounting::FixedAssets::CommoditiesControllerTest < ActionController::TestCase
  setup do
    login users(:joe)
    @commodity = fixed_assets_commodities(:commodity_one)
  end

  test 'should get all commodities' do
    skip
    get :index
    assert_response :success

    assert_template "index", "Template should be index"
  end

  test 'should show commodity' do
    skip
    request = {id: @commodity.id}

    get :show, request
    assert_response :success

    assert_template "edit", "Template should be edit"
  end

  test 'should show new commodity form' do
    skip
    get :new
    assert_response :success

    assert_template 'new', 'Template should be new'
  end

  test 'should get create new commodity' do
    skip
    assert_difference('Accounting::FixedAssets::Commodity.count',1) do
      patch :create, accounting_fixed_assets_commodity: {
            nimitys: 'Chair30000',
            selite: 'Chair for CEO'
      }
      assert_response :found
      assert_redirected_to accounting_fixed_assets_commodities_path
    end
  end

  test 'should update commodity and create bookkeeping rows type T and P' do
    skip
    # Creates external bookkeeping reductions only for current fiscal year
    assert_difference('Accounting::FixedAssets::Row.count', 5) do
      # Creates internal bookkeeping reductions only for current fiscal year
      assert_difference('Accounting::Row.count', 5) do
        patch :update, id: @commodity.id, accounting_fixed_assets_commodity: {
          nimitys: 'Chair50000',
          selite: 'Chair for CEO',
          summa: 10000.0,
          tilino: @account.tilino,
          sumu_poistotyyppi: 'T',
          sumu_poistoera: 12,
          evl_poistotyyppi: 'P',
          evl_poistoera: 45,
          kayttoonottopvm: Time.now,
          hankintapvm: Time.now,
          tila: 'A'
        }
      end
    end
  end

  test 'should update commodity and create bookkeeping rows type D and B' do
    skip
    # Creates external bookkeeping reductions only for current fiscal year
    assert_difference('Accounting::FixedAssets::Row.count', 5) do
      # Creates internal bookkeeping reductions only for current fiscal year
      assert_difference('Accounting::Row.count', 5) do
        patch :update, id: @commodity.id, accounting_fixed_assets_commodity: {
          nimitys: 'Chair50000',
          selite: 'Chair for CEO',
          summa: 10000.0,
          tilino: @account.tilino,
          sumu_poistotyyppi: 'D',
          sumu_poistoera: 12,
          evl_poistotyyppi: 'B',
          evl_poistoera: 45,
          kayttoonottopvm: Time.now,
          hankintapvm: Time.now,
          tila: 'A'
        }
      end
    end

    assert_redirected_to accounting_fixed_assets_commodities_path
    assert_equal "Hyödyke päivitettiin onnistuneesti.", flash[:notice]
  end

  test 'should not create new commodity due to permissions' do
    skip
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

  test 'should not create new commodity due to params missing' do
    skip
    assert_no_difference('Accounting::FixedAssets::Commodity.count') do
      post :create, accounting_fixed_assets_commodity: {
        nimitys: '', selite: '', summa: 300, tila: 'A'
      }
    end

    assert_template 'new', 'Template should be new'
  end

  test 'should update commodity' do
    skip
    patch :update, id: @commodity.id, accounting_fixed_assets_commodity: {
      nimitys: 'Kissa'
    }

    assert_redirected_to accounting_fixed_assets_commodities_path
    assert_equal "Hyödyke päivitettiin onnistuneesti.", flash[:notice]
  end

  test 'should not update commodity due to rights' do
    skip
    cookies[:pupesoft_session] = users(:bob).session

    patch :update, id: @commodity.id, accounting_fixed_assets_commodity: {nimi: ''}

    assert_redirected_to accounting_fixed_assets_commodities_path
    assert_equal "Sinulla ei ole päivitysoikeuksia.", flash[:notice]
  end

  test 'should not update commodity due to required params missing' do
    skip
    patch :update, id: @commodity.id, accounting_fixed_assets_commodity: {nimitys: ''}

    assert_template 'edit', 'Template should be edit'
  end

  test 'should link commodity cost row' do
    skip
    unlinked_row = accounting_rows(:three_accounting_row)
    assert_difference('Accounting::FixedAssets::CommodityCostRow.count') do
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

  test 'should execute fiscal year run' do
    skip
    get :fiscal_year_run
    assert_response :success
  end
end
