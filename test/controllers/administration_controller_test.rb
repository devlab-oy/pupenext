require 'test_helper'

#The purpose of AdministrationControllerTest is to test the common logic behind AdministrationController
class AdministrationControllerTest < ActionController::TestCase
  tests Administration::SumLevelsController

  def setup
    cookies[:pupesoft_session] = users(:joe).session
    @sum_level = sum_levels(:external)
  end

  test "should not get resources index" do
    cookies[:pupesoft_session] = users(:ben).session
    get :index
    assert_response :forbidden
  end

  test "should not get resources new" do
    get :new
    assert_redirected_to sum_levels_path
  end

  test "should show resource with read access" do
    request = { id: @sum_level.id }
    get :show, request
    assert_response :success
  end

  test "should not show resource" do
    cookies[:pupesoft_session] = users(:ben).session
    request = { id: @sum_level.id }
    get :show, request
    assert_response :forbidden
  end

  test "should not create resource with no access" do
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


  test "should not get resources edit" do
    cookies[:pupesoft_session] = users(:ben).session
    request = { id: @sum_level.id }
    get :edit, request
    assert_response :forbidden
  end

  test "should get resources edit without update access" do
    request = { id: @sum_level.id }
    get :edit, request
    assert_response :success
  end

  test "should not update resource" do
    patch :update, id: @sum_level.id, sum_level: { nimi: 'Uusi nimi' }
    assert_equal "Sinulla ei ole päivitysoikeuksia", flash[:notice]
    assert_redirected_to sum_levels_path
  end

  test "should not destroy resource" do
    assert_no_difference('SumLevel.count') do
      delete :destroy, id: @sum_level.id
    end

    assert_equal "Sinulla ei ole päivitysoikeuksia", flash[:notice]
    assert_redirected_to sum_levels_path
  end
end
