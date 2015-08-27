require 'test_helper'

class Administration::TermsOfPaymentsControllerTest < ActionController::TestCase
  fixtures %w(terms_of_payments)

  setup do
    login users(:bob)
    @joe = users(:joe)
    @top = terms_of_payments(:sixty_days_net)
  end

  test 'should get index' do
    login @joe
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
    assert_response :success
  end

  test 'should create terms of payment' do
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
    assert_no_difference('TermsOfPayment.count') do

      params = { not_existing_column: true }

      post :create, terms_of_payment: params
      assert_template "edit", "Template should be edit"
    end
  end

  test 'should update terms of payment' do
    params = { teksti: "Kepakko" }

    patch :update, id: @top.id, terms_of_payment: params
    assert_redirected_to terms_of_payments_path
  end

  test 'should not update terms of payment' do
    params = { rel_pvm: 'a' }

    patch :update, id: @top.id, terms_of_payment: params
    assert_template "edit", "Template should be edit"
  end

  test 'should show terms of payments not in use' do
    login @joe
    params = { not_used: :yes }

    get :index, params
    assert_response :success
    assert_not_nil assigns(:terms_of_payments)
    assert_select "input" do |elements|
      assert_select elements, "input", { type: "submit", value: "Näytä aktiivit" }
    end
  end

  test "should add translations" do
    params = {
      translations_attributes: {
        "0" => {
          kieli: 'no',
          selitetark: '60 dagar netto',
        }
      }
    }

    assert_difference('Keyword::TermsOfPaymentTranslation.count') do
      patch :update, id: @top.id, terms_of_payment: params
    end
  end

  test "should update and destroy translations" do
    translated = keywords(:top_locale_se)

    params = {
      translations_attributes: {
        "0" => {
          id: translated.id,
          selitetark: 'a translation',
        }
      }
    }

    assert_no_difference('Keyword::TermsOfPaymentTranslation.count') do
      patch :update, id: translated.terms_of_payment.id, terms_of_payment: params
    end

    assert_equal 'a translation', translated.reload.selitetark

    params = {
      translations_attributes: {
        "0" => {
          id: translated.id,
          _destroy: 'true',
        }
      }
    }

    assert_difference('Keyword::TermsOfPaymentTranslation.count', -1) do
      patch :update, id: translated.terms_of_payment.id, terms_of_payment: params
    end
  end
end
