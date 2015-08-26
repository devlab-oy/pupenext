require 'test_helper'

# The purpose of AdministrationControllerTest is to test the common logic behind AdministrationController
class AdministrationControllerTest < ActionController::TestCase
  tests Administration::SumLevelsController

  fixtures %w(sum_levels)

  setup do
    login users(:joe)
    @sum_level = sum_levels(:external)
  end

  test "should not get resources index" do
    login users(:max)

    get :index
    assert_response :forbidden
  end

  test "should not get resources new" do
    get :new
    assert_response :forbidden
  end

  test "should show resource with read access" do
    request = { id: @sum_level.id }
    get :show, request
    assert_response :success
  end

  test "should not show resource" do
    login users(:max)

    request = { id: @sum_level.id }
    get :show, request
    assert_response :forbidden
  end

  test "should not create resource with no access" do
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

    assert_response :forbidden
  end


  test "should not get resources edit" do
    login users(:max)

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
    assert_response :forbidden
  end

  test "should not destroy resource" do
    assert_no_difference('SumLevel.count') do
      delete :destroy, id: @sum_level.id
    end

    assert_response :forbidden
  end
end
