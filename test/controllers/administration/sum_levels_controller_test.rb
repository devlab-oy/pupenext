require 'test_helper'

class Administration::SumLevelsControllerTest < ActionController::TestCase
  def setup
    cookies[:pupesoft_session] = users(:joe).session
    @user = users(:joe)
    @sum_level = sum_levels(:external)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should not get index" do
    cookies[:pupesoft_session] = users(:ben).session
    get :index
    assert_response :forbidden
  end

  test "should get new" do
    cookies[:pupesoft_session] = users(:bob).session
    get :new
    assert_response :success
  end

  test "should not get new" do
    get :new
    assert_redirected_to sum_levels_path
  end

  test "should show sum level" do
    request = { id: @sum_level.id }
    get :show, request
    assert_response :success
  end

  test "should show sum level with read access" do
    request = { id: @sum_level.id }
    get :show, request
    assert_response :success
  end

  test "should not show sum level" do
    cookies[:pupesoft_session] = users(:ben).session
    request = { id: @sum_level.id }
    get :show, request
    assert_response :forbidden
  end

  test "should create" do
    cookies[:pupesoft_session] = users(:bob).session
    assert_difference('SumLevel.count', 1) do
      request = {
        tyyppi: 'U',
        summattava_taso: '',
        taso: '2221',
        nimi: 'TILIKAUDEN TULOS2221',
        oletusarvo: '',
        jakaja: '',
        kumulatiivinen: '',
        kayttotarkoitus: '',
        kerroin: '',
      }
      post :create, sum_level: request
    end

    assert_redirected_to sum_levels_path
  end

  test "should not create" do
    assert_no_difference('SumLevel.count') do
      #With non-valid request
      request = {
        tyyppi: 'U',
        summattava_taso: '',
        taso: '',
        nimi: 'TILIKAUDEN TULOS2221',
        oletusarvo: '',
        jakaja: '',
        kumulatiivinen: '',
        kayttotarkoitus: '',
        kerroin: '',
      }
      post :create, sum_level: request
    end

    assert_redirected_to sum_levels_path
  end

  test "should not create with no access" do
    cookies[:pupesoft_session] = users(:joe).session
    assert_no_difference('SumLevel.count') do
      #With valid request
      request = {
        tyyppi: 'U',
        summattava_taso: '',
        taso: '29',
        nimi: 'TILIKAUDEN TULOS2221',
        oletusarvo: '',
        jakaja: '',
        kumulatiivinen: '',
        kayttotarkoitus: '',
        kerroin: '',
      }
      post :create, sum_level: request
    end

    assert_redirected_to sum_levels_path
  end

  test "should get edit" do
    cookies[:pupesoft_session] = users(:bob).session
    request = { id: @sum_level.id }
    get :edit, request
    assert_response :success
  end

  test "should not get edit" do
    cookies[:pupesoft_session] = users(:ben).session
    request = { id: @sum_level.id }
    get :edit, request
    assert_response :forbidden
  end

  test "should get edit without update access" do
    request = { id: @sum_level.id }
    get :edit, request
    assert_response :success
  end

  test "should update" do
    cookies[:pupesoft_session] = users(:bob).session
    patch :update, id: @sum_level.id, sum_level: { nimi: 'Uusi nimi' }
    assert_equal "Taso päivitettiin onnistuneesti", flash[:notice]
    assert_redirected_to sum_levels_path
  end

  test "should not update" do
    patch :update, id: @sum_level.id, sum_level: { nimi: 'Uusi nimi' }
    assert_equal "Sinulla ei ole päivitysoikeuksia", flash[:notice]
    assert_redirected_to sum_levels_path
  end

  test "should not update with invalid data" do
    cookies[:pupesoft_session] = users(:bob).session
    patch :update, id: @sum_level.id, sum_level: { taso: '' }
    assert_template :edit
  end

  test "should destroy" do
    cookies[:pupesoft_session] = users(:bob).session
    assert_difference('SumLevel.count', -1) do
      delete :destroy, id: @sum_level.id
    end

    assert_equal "Taso poistettiin onnistuneesti", flash[:notice]
    assert_redirected_to sum_levels_path
  end

  test "should not destroy" do
    assert_no_difference('SumLevel.count') do
      delete :destroy, id: @sum_level.id
    end

    assert_equal "Sinulla ei ole päivitysoikeuksia", flash[:notice]
    assert_redirected_to sum_levels_path
  end
end
