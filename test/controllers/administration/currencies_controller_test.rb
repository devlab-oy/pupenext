require 'test_helper'

class Administration::CurrenciesControllerTest < ActionController::TestCase
  def setup
    cookies[:pupesoft_session] = users(:joe).session
  end

  test 'should get all currencies' do
    get :index
    assert_response :success

    assert_template "index", "Template should be index"
  end

  test 'should show currency' do
    currency = currencies(:eur)
    request = { id: currency.id }

    get :show, request
    assert_response :success

    assert_template "edit", "Template should be edit"
  end

  test 'should show new currency form' do
    get :new
    assert_response :success

    assert_template 'new', 'Template should be new'
  end

  test 'should search for specific currency' do
    request = { nimi: 'EUR' }

    get :index, request
    assert_response :success

    assert_template "index", "Template should be index"
  end

  test 'should not have permission to create new currency' do
    assert_no_difference('Currency.count') do
      post :create, currency: { nimi: 'TES', kurssi: 0.8 }
    end

    assert_redirected_to currencies_path
    assert_equal "Sinulla ei ole päivitysoikeuksia", flash[:notice]
  end

  test 'should create new currency' do
    cookies[:pupesoft_session] = users(:bob).session

    assert_difference('Currency.count') do
      post :create, currency: { nimi: 'TES', kurssi: 0.8 }
    end

    assert_redirected_to currencies_path
    assert_equal "Valuutta luotiin onnistuneesti", flash[:notice]
  end

  test 'should not create new currency' do
    cookies[:pupesoft_session] = users(:bob).session

    assert_no_difference('Currency.count') do
      post :create, currency: { nimi: 'FOO_BAR' }
      assert_template 'new', 'Template should be new'
    end
  end

  test 'should update currency' do
    cookies[:pupesoft_session] = users(:bob).session
    currency = currencies(:eur)

    patch :update, id: currency.id, currency: { nimi: 'TES' }

    assert_redirected_to currencies_path, response.body
    assert_equal "Valuutta päivitettiin onnistuneesti", flash[:notice]
  end

  test 'should not see intrastat-field' do
    cookies[:pupesoft_session] = users(:bob).session
    currency = currencies(:eur)

    request = { id: currency.id }

    get :show, request
    assert_select "table tr", 7, "User is not from Estonia and should see only 7 table rows"
  end

  test 'should see intrastat-field' do
    cookies[:pupesoft_session] = users(:max).session
    currency = currencies(:eur_ee)

    request = { id: currency.id }

    get :show, request
    assert_select "table tr", 8, "User is from Estonia and should see 8 table rows"
  end

  test 'should update estonian currency' do
    cookies[:pupesoft_session] = users(:max).session
    currency = currencies(:eur_ee)

    patch :update, id: currency.id, currency: { nimi: 'TES', intrastat_kurssi: 1.5 }

    assert_redirected_to currencies_path, response.body
    assert_equal "Valuutta päivitettiin onnistuneesti", flash[:notice]

    request = { id: currency.id }

    get :show, request

    assert_select "input#currency_intrastat_kurssi" do
      assert_select "[value=?]", 1.5
    end
  end

  test 'should not update currency' do
    cookies[:pupesoft_session] = users(:bob).session
    currency = currencies(:eur)

    patch :update, id: currency.id, currency: { nimi: '' }

    assert_template 'edit', 'Template should be edit'
  end
end
