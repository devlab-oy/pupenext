require 'test_helper'

class Administration::CarriersControllerTest < ActionController::TestCase
  def setup
    login users(:joe)
    @carrier = carrier(:hit)
  end

  test 'should get index' do
    get :index
    assert_response :success

    assert_template "index", "Template should be index"
  end

  test 'should get edit' do
    login users(:bob)
    get :edit, id: @carrier.tunnus
    assert_response :success

    get :show, id: @carrier.tunnus
    assert_response :success
    assert_template "edit", "Template should be edit"
  end

  test 'should get new' do
    login users(:bob)
    get :new
    assert_response :success
  end

  test 'should create carrier' do
    login users(:bob)

    assert_difference("Carrier.count", 1, response.body) do

      params = {
        nimi: "Kiitolinja",
        koodi: "KIITO",
        jalleenmyyjanro: 123456789,
        neutraali: "o",
        pakkauksen_sarman_minimimitta: 1.0
      }

      post :create, carrier: params
      assert_redirected_to carriers_path
    end
  end

  test 'should not create carrier' do
    login users(:bob)

    assert_no_difference("Carrier.count") do

      params = { not_existing_column: true }

      post :create, carrier: params
      assert_template "new", "Template should be new"
    end
  end

  test 'should update carrier' do
    login users(:bob)

    params = { nimi: "Posti" }

    patch :update, id: @carrier.id, carrier: params
    assert_redirected_to carriers_path
  end

  test 'should not update carrier' do
    login users(:bob)

    params = { pakkauksen_sarman_minimimitta: 'a' }

    patch :update, id: @carrier.id, carrier: params
    assert_template "edit", "Template should be edit"
  end

  test "should delete carrier" do
    login users(:bob)

    assert_difference("Carrier.count", -1) do
      delete :destroy, id: @carrier.id
    end

    assert_redirected_to carriers_path
  end
end
