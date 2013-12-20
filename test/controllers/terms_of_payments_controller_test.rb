require 'test_helper'

class TermsOfPaymentsControllerTest < ActionController::TestCase

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
    get :edit, id: @top.tunnus
    assert_response :success
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'show should be edit' do
    get :show, id: @top.tunnus
  end

  test 'should create terms of payment' do
    assert_difference('TermsOfPayment.count') do

      params = {
        teksti: "60 pv netto 2",
        rel_pvm: 60,
        abs_pvm: Date.today,
        kassa_relpvm: 14,
        kassa_abspvm: Date.today,
        kassa_alepros: 0.00,
        osamaksuehto1: 0,
        osamaksuehto2: 0,
        summanjakoprososa2: 0.0000,
        jv: '',
        kateinen: '',
        suoraveloitus: '',
        factoring: '',
        pankkiyhteystiedot: 0,
        itsetulostus: '',
        jaksotettu: '',
        erapvmkasin: '',
        sallitut_maat: '',
        kaytossa: '',
        jarjestys: 1
      }

      post :create, terms_of_payment: params
      assert_redirected_to terms_of_payments_path
    end
  end

  test 'should not create terms of payment' do
    assert_no_difference('TermsOfPayment.count') do

      params = {}

      post :create, terms_of_payment: params
      assert_template "new", "Template should be new"
    end
  end

  test 'should update terms of payment' do

    params = { teksti: "Kepakko" }

    patch :update, id: @top.id, terms_of_payment: params
    assert_redirected_to terms_of_payments_path
  end

  test 'should not update terms of payment' do

    params = { teksti: '' }

    patch :update, id: @top.id, terms_of_payment: params
    assert_template "edit", "Template should be edit"
  end

end
