require 'test_helper'

class FixedAssets::CommoditiesControllerTest < ActionController::TestCase
  fixtures %w(
    accounts
    companies
    fiscal_years
    fixed_assets/commodities
    fixed_assets/commodity_rows
    head/voucher_rows
    heads
    sum_levels
  )

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
      status: ''
    }

    patch :update, id: @commodity.id, fixed_assets_commodity: params

    assert_redirected_to edit_commodity_path assigns(:commodity)
    assert_equal params[:planned_depreciation_type], assigns(:commodity).planned_depreciation_type

    assert_response :found
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
    params = {
      commodity_id: @commodity.id,
      voucher_row_id: head_voucher_rows(:nine).id
    }

    assert_difference("Head::VoucherRow.where(commodity_id: #{@commodity.id}).count") do
      post :link_voucher, params
    end

    assert_redirected_to commodity_vouchers_path
  end

  test 'linking first voucher' do
    b = @commodity.dup
    b.status = nil
    assert b.save, b.errors.full_messages

    params = {
      commodity_id: b.id,
      voucher_row_id: head_voucher_rows(:nine).id
    }

    assert_difference("Head::VoucherRow.where(commodity_id: #{b.id}).count") do
      post :link_voucher, params
    end

    assert_redirected_to commodity_vouchers_path

    # Second time should not update
    post :link_voucher, params
    assert_template :vouchers
  end

  test 'should not link voucher_row with wrong account number' do
    params = {
      commodity_id: @commodity.id,
      voucher_row_id: head_voucher_rows(:eight).id
    }

    assert_not_equal @commodity.fixed_assets_account, head_voucher_rows(:eight).tilino

    assert_no_difference("Head::VoucherRow.where(commodity_id: #{@commodity.id}).count") do
      post :link_voucher, params
    end
    assert_nil head_voucher_rows(:eight).commodity_id
    assert_template 'vouchers'
  end

  test 'should get link purchase order' do
    get :purchase_orders, commodity_id: @commodity.id
    assert_response :success
  end

  test 'should update link purchase order' do
    params = {
      commodity_id: @commodity.id,
      voucher_row_id: head_voucher_rows(:thirteen).id
    }

    assert_difference("Head::VoucherRow.where(commodity_id: #{@commodity.id}).count") do
      post :link_order, params
    end

    assert_redirected_to commodity_purchase_orders_path

    # Second time should not update
    post :link_order, params
    assert_template :purchase_orders
  end

  test 'should not update link purchase order with wrong account number' do
    params = {
      commodity_id: @commodity.id,
      voucher_row_id: head_voucher_rows(:twelve).id
    }
    assert_not_equal @commodity.fixed_assets_account, head_voucher_rows(:twelve).tilino

    assert_no_difference("Head::VoucherRow.where(commodity_id: #{@commodity.id}).count") do
      post :link_order, params
    end
    assert_nil head_voucher_rows(:twelve).commodity_id
    assert_template 'purchase_orders'
  end

  test 'should activate commodity' do
    params = {
      commodity_id: @commodity.id
    }
    @commodity.status = ''
    @commodity.save!

    post :activate, params
    @commodity.reload

    assert_equal 'A', @commodity.status
    assert_redirected_to edit_commodity_path assigns(:commodity)
  end

  test 'should not activate commodity' do
    params = {
      commodity_id: @commodity.id
    }
    @commodity.status = ''
    @commodity.procurement_rows.delete_all
    @commodity.save!

    post :activate, params
    @commodity.reload
    assert_equal '', @commodity.status
    assert_template :edit, 'Template should be edit'
  end

  test 'should unlink row' do
    # Link a second row so there is something to remove
    params = {
      commodity_id: @commodity.id,
      voucher_row_id: head_voucher_rows(:thirteen).id
    }
    post :link_order, params
    assert_equal 2, @commodity.procurement_rows.count

    params = {
      commodity_id: @commodity.id,
      voucher_row_id: head_voucher_rows(:thirteen).id
    }
    post :unlink, params
    assert_equal 1, @commodity.procurement_rows.count

    @commodity.status = ''
    @commodity.save!

    # Last row can be removed from unactivated commodity
    params = {
      commodity_id: @commodity.id,
      voucher_row_id: @commodity.procurement_rows.first.id
    }
    post :unlink, params
    assert_equal 0, @commodity.procurement_rows.count
    # Unlinking already unlinked should not work
    post :unlink, params
    assert_template :edit
  end

  test 'should not unlink last row' do
    assert_equal 1, @commodity.procurement_rows.count
    params = {
      commodity_id: @commodity.id,
      voucher_row_id: @commodity.procurement_rows.first.id
    }
    post :unlink, params
    assert_equal 1, @commodity.procurement_rows.count
    assert_template :edit
  end

  test 'should get sell' do
    get :sell, commodity_id: @commodity.id
    assert_response :success

    assert_template :sell, 'Template should be sell'
  end

  test 'should sell commodity' do
    salesparams = {
      commodity_id: @commodity.id,
      amount_sold: 2000,
      deactivated_at: Date.today,
      profit_account: accounts(:account_100).tilino,
      sales_account: accounts(:account_110).tilino,
      depreciation_remainder_handling: 'S',
    }

    post :confirm_sale, salesparams
    assert_redirected_to edit_commodity_path assigns(:commodity)

    @commodity.reload
    assert_equal 'P', @commodity.status
  end

  test 'should not sell commodity' do
    params = {
      commodity_id: @commodity.id,
      sales_amount: 9800,
      sales_date: Date.today,
      profit_account: 0,
      sales_account: accounts(:account_110).tilino,
      depreciation_handling: 'S'
    }
    post :confirm_sale, params

    assert_template :_form_errors
    assert_template :sell
    @commodity.reload
    assert_equal 'A', @commodity.status
  end

  test 'should generate rows' do
    params = {
      commodity_id: @commodity.id,
      fiscal_id: fiscal_years(:two),
      user_id: users(:bob).id
    }

    post :generate_rows, params
    assert_response :found
    assert assigns(:commodity).commodity_rows
    assert assigns(:commodity).voucher.rows
  end

  test 'should delete generated rows' do
    params = {
      commodity_id: @commodity.id,
      fiscal_id: fiscal_years(:two),
      user_id: users(:bob).id
    }
    post :generate_rows, params
    assert_equal 9, assigns(:commodity).commodity_rows.count
    assert_equal 36, assigns(:commodity).voucher.rows.count

    post :delete_rows, params
    assert_response :found
    assert_equal 0, assigns(:commodity).commodity_rows.count
    assert_equal 0, assigns(:commodity).voucher.rows.count
  end

  test 'should destroy commodity and procurement rows if viable' do
    params = {
      commodity_id: @commodity.id,
      fiscal_id: fiscal_years(:two),
      user_id: users(:bob).id
    }
    post :generate_rows, params
    assert_equal 9, assigns(:commodity).commodity_rows.count
    assert_equal 36, assigns(:commodity).voucher.rows.count

    # Fails because commodity and voucher rows exist
    post :destroy_commodity, params
    assert_response :found
    assert_redirected_to edit_commodity_path assigns(:commodity)

    post :delete_rows, params
    assert_response :found
    assert_equal 0, assigns(:commodity).commodity_rows.count
    assert_equal 0, assigns(:commodity).voucher.rows.count

    # Only 1 commodity exists and it can be destroyed
    assert_equal 1, companies(:acme).commodities.count
    assert_equal true, @commodity.can_be_destroyed?

    # Commodity procurement row count
    assert_equal 1, Head::VoucherRow.where.not(commodity_id: nil).count

    # Succeeds because no commodity or voucher rows exist
    post :destroy_commodity, params
    assert_response :found
    assert_redirected_to commodities_path
    assert_equal 0, companies(:acme).commodities.count

    # Test that related records are destroyed
    # Commodity procurement row count
    assert_equal 0, Head::VoucherRow.where.not(commodity_id: nil).count
  end
end
