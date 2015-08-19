require 'test_helper'

class Administration::TermsOfPaymentsControllerTest < ActionController::TestCase

  def setup
    cookies[:pupesoft_session] = users(:joe).session
    @top = terms_of_payments(:sixty_days_net)
  end

  test 'should get index' do
    get :index
    assert_response :success

    assert_template "index", "Template should be index"
  end

  test 'should get edit' do
    cookies[:pupesoft_session] = users(:bob).session
    get :edit, id: @top.tunnus
    assert_response :success
  end

  test 'should get new' do
    cookies[:pupesoft_session] = users(:bob).session
    get :new
    assert_response :success
  end

  test 'show should be edit' do
    cookies[:pupesoft_session] = users(:bob).session
    get :show, id: @top.tunnus
    assert_response :success
  end

  test 'should create terms of payment' do
    cookies[:pupesoft_session] = users(:bob).session

    assert_difference('TermsOfPayment.count', 1, response.body) do

      params = {
        teksti: "60 pv netto 2",
        rel_pvm: 60,
        abs_pvm: Date.today,
        pankkiyhteystiedot: nil,
        kassa_relpvm: 14,
        kassa_abspvm: Date.today,
        jarjestys: 1
      }

      post :create, terms_of_payment: params
      assert_redirected_to terms_of_payments_path
    end
  end

  test 'should not create terms of payment' do
    cookies[:pupesoft_session] = users(:bob).session
    assert_no_difference('TermsOfPayment.count') do

      params = { not_existing_column: true }

      post :create, terms_of_payment: params
      assert_template "edit", "Template should be edit"
    end
  end

  test 'should update terms of payment' do
    cookies[:pupesoft_session] = users(:bob).session

    params = { teksti: "Kepakko" }

    patch :update, id: @top.id, terms_of_payment: params
    assert_redirected_to terms_of_payments_path
  end

  test 'should not update terms of payment' do
    cookies[:pupesoft_session] = users(:bob).session

    params = { rel_pvm: 'a' }

    patch :update, id: @top.id, terms_of_payment: params
    assert_template "edit", "Template should be edit"
  end

  test 'should show terms of payments not in use' do
    params = { not_used: :yes }

    get :index, params
    assert_response :success
    assert_not_nil assigns(:terms_of_payments)
    assert_select "input" do |elements|
      assert_select elements, "input", { type: "submit", value: "Näytä aktiivit" }
    end
  end

end
