require 'test_helper'

class Administration::SumLevelsControllerTest < ActionController::TestCase
  fixtures %w(sum_levels)

  setup do
    login users(:bob)
    @sum_level = sum_levels(:external)
  end

  test "should get index" do
    login users(:joe)

    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should show sum level" do
    login users(:joe)

    request = { id: @sum_level.id }
    get :show, request
    assert_response :success
  end

  test "should create" do
    assert_difference('SumLevel.count', 1) do
      request = {
        sum_level: {
          tyyppi: 'U',
          summattava_taso: '',
          taso: '2221',
          nimi: 'TILIKAUDEN TULOS2221',
          oletusarvo: '',
          jakaja: '',
          kumulatiivinen: 'not_cumulative',
          kayttotarkoitus: 'normal',
          kerroin: ''
        },
        commit: "joo"
      }
      post :create, request
    end

    assert_redirected_to sum_levels_path
  end

  test "does not create with invalid params" do
    request = {
      tyyppi: 'U',
      summattava_taso: '',
      taso: '',
      nimi: 'TILIKAUDEN TULOS2221',
      oletusarvo: '',
      jakaja: '',
      kumulatiivinen: '',
      kayttotarkoitus: '',
      kerroin: ''
    }

    assert_no_difference("SumLevel.count") do
      post :create, sum_level: request
    end

    assert_template :edit
  end

  test "should get edit" do
    request = { id: @sum_level.id }
    get :edit, request
    assert_response :success
  end

  test "should update" do
    patch :update, id: @sum_level.id, commit: "yes", sum_level: { nimi: 'Uusi nimi' }
    assert_equal "Taso päivitettiin onnistuneesti", flash[:notice]
    assert_redirected_to sum_levels_path
  end

  test "should not update if commit not present in params" do
    patch :update, id: @sum_level.id, sum_level: { nimi: 'Uusi nimi' }
    assert_template :edit
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
end
