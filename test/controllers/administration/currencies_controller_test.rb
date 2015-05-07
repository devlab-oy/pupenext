require 'test_helper'

class Administration::CurrenciesControllerTest < ActionController::TestCase
  def setup
    login users(:joe)
  end

  test 'should get all currencies' do
    get :index
    assert_response :success
    assert_template "index", "Template should be index"
  end

  test 'should show currency' do
    currency = currencies(:eur)
    request = {id: currency.id}

    get :show, request
    assert_response :success
    assert_template "edit", "Template should be edit"
  end

  test 'should show new currency form' do
    login users(:bob)

    get :new
    assert_response :success
  end

  test 'should not show new currency form' do
    get :new
    assert_response :forbidden
  end

  test 'should search for specific currency' do
    request = {nimi: 'EUR'}

    get :index, request
    assert_response :success
    assert_template "index", "Template should be index"
  end

  test 'should not have permission to create new currency' do
    assert_no_difference('Currency.count') do
      post :create, currency: {nimi: 'TES', kurssi: 0.8}
    end

    assert_response :forbidden
  end

  test 'should create new currency' do
    login users(:bob)

    assert_difference('Currency.count') do
      post :create, currency: {nimi: 'TES', kurssi: 0.8}
    end

    assert_redirected_to currencies_path
    assert_equal "Valuutta luotiin onnistuneesti.", flash[:notice]
  end

  test 'should not create new currency' do
    login users(:bob)

    assert_no_difference('Currency.count') do
      post :create, currency: {nimi: 'FOO_BAR'}
      assert_template 'new', 'Template should be new'
    end
  end

  test 'should update currency' do
    login users(:bob)
    currency = currencies(:eur)

    patch :update, id: currency.id, currency: {nimi: 'TES'}
    assert_redirected_to currencies_path, response.body
    assert_equal "Valuutta päivitettiin onnistuneesti.", flash[:notice]
  end

  test 'should not see intrastat-field' do
    login users(:bob)
    currency = currencies(:eur)
    request = {id: currency.id}

    get :show, request
    assert_select "table tr", 7, "User is not from Estonia and should see only 7 table rows"
  end

  # These tests are currently disabled because we are logged in with other companys user.
  # test 'should see intrastat-field' do
  #   login users(:max)
  #   currency = currencies(:eur_ee)
  #   request = {id: currency.id}
  #
  #   get :show, request
  #   assert_select "table tr", 8, "User is from Estonia and should see 8 table rows"
  # end

  # test 'should update estonian currency' do
  #   login users(:max)
  #   currency = currencies(:eur_ee)
  #
  #   patch :update, id: currency.id, currency: {nimi: 'TES', intrastat_kurssi: 1.5}
  #   assert_redirected_to currencies_path, response.body
  #   assert_equal "Valuutta päivitettiin onnistuneesti.", flash[:notice]
  # end

  test 'should not update currency' do
    login users(:bob)
    currency = currencies(:eur)

    patch :update, id: currency.id, currency: {nimi: ''}
    refute_equal '', currency.reload.nimi
    assert_template 'edit', 'Template should be edit'
  end
end
