require 'test_helper'

class SumLevelsControllerTest < ActionController::TestCase
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
    @user.revoke_all "pupenext/sum_levels"
    get :index
    assert_response :forbidden
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should not get new" do
    @user.revoke_all "pupenext/sum_levels"
    get :new
    assert_response :forbidden
  end

  test "should show sum level" do
    request = { id: @sum_level.id }
    get :show, request
    assert_response :success
  end

  test "should show sum level with read access" do
    @user.revoke_update_access "pupenext/sum_levels"
    request = { id: @sum_level.id }
    get :show, request
    assert_response :success
  end

  test "should not show sum level" do
    @user.revoke_all "pupenext/sum_levels"
    request = { id: @sum_level.id }
    get :show, request
    assert_response :forbidden
  end

  test "should create" do
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

    assert_template :edit
  end

  test "should not create with no access" do
    #With unsufficient access
    @user.revoke_update_access "pupenext/sum_levels"
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
    request = { id: @sum_level.id }
    get :edit, request
    assert_response :success
  end

  test "should not get edit" do
    @user.revoke_all "pupenext/sum_levels"
    request = { id: @sum_level.id }
    get :edit, request
    assert_response :forbidden
  end

  test "should get edit without update access" do
    @user.revoke_update_access "pupenext/sum_levels"
    request = { id: @sum_level.id }
    get :edit, request
    assert_response :success
  end

  test "should update" do
    patch :update, id: @sum_level.id, sum_level: { nimi: 'Uusi nimi' }
    assert_equal "Taso päivitettiin onnistuneesti", flash[:notice]
    assert_redirected_to sum_levels_path
  end

  test "should not update" do
    @user.revoke_update_access "pupenext/sum_levels"
    patch :update, id: @sum_level.id, sum_level: { nimi: 'Uusi nimi' }
    assert_equal "Sinulla ei ole päivitysoikeuksia", flash[:notice]
    assert_redirected_to sum_levels_path
  end

  test "should not update with invalid data" do
    patch :update, id: @sum_level.id, sum_level: { taso: '' }
    assert_template :edit
  end

  test "should destroy" do
    assert_difference('SumLevel.count', -1) do
      delete :destroy, id: @sum_level.id
    end

    assert_equal "Taso poistettiin onnistuneesti", flash[:notice]
    assert_redirected_to sum_levels_path
  end

  test "should not destroy" do
    @user.revoke_update_access "pupenext/sum_levels"
    assert_no_difference('SumLevel.count') do
      delete :destroy, id: @sum_level.id
    end

    assert_equal "Sinulla ei ole päivitysoikeuksia", flash[:notice]
    assert_redirected_to sum_levels_path
  end
end
