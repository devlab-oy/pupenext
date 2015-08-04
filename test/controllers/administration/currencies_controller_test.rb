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
    message = I18n.t 'administration.currencies.create.create_success'
    assert_equal message, flash[:notice]
  end

  test 'should not create new currency' do
    login users(:bob)

    assert_no_difference('Currency.count') do
      post :create, currency: {nimi: 'FOO_BAR'}
      assert_template 'edit', 'Template should be edit'
    end
  end

  test 'should update currency' do
    login users(:bob)
    currency = currencies(:eur)

    patch :update, id: currency.id, currency: {nimi: 'TES'}
    assert_redirected_to currencies_path, response.body
    message = I18n.t 'administration.currencies.update.update_success'
    assert_equal message, flash[:notice]
  end

  test 'users not from estonia should not see intrastat-field' do
    login users(:bob)
    currency = currencies(:eur)
    request = {id: currency.id}

    get :show, request
    assert_select 'label[for=currency_intrastat_kurssi]', { count: 0 }, 'no intrastat label'
    assert_select 'input[id=currency_intrastat_kurssi]', { count: 0 }, 'no intrastat input'
  end

  test 'user from estonia should see intrastat-field' do
    login users(:max)
    currency = currencies(:eur_ee)
    request = {id: currency.id}

    get :show, request
    assert_select 'label[for=currency_intrastat_kurssi]', { count: 1 }, 'must have intrastat label'
    assert_select 'input[id=currency_intrastat_kurssi]', { count: 1 }, 'must have intrastat input'
  end

  test 'should update estonian currency' do
    login users(:max)
    currency = currencies(:eur_ee)

    patch :update, id: currency.id, currency: {nimi: 'TES', intrastat_kurssi: 1.5}
    assert_redirected_to currencies_path, response.body
    message = I18n.t 'administration.currencies.update.update_success'
    assert_equal message, flash[:notice]
  end

  test 'should not update currency' do
    login users(:bob)
    currency = currencies(:eur)

    patch :update, id: currency.id, currency: {nimi: ''}
    refute_equal '', currency.reload.nimi
    assert_template 'edit', 'Template should be edit'
  end
end
