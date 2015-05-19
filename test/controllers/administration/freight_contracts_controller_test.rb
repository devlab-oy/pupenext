require 'test_helper'

class Administration::FreightContractsControllerTest < ActionController::TestCase
  setup do
    login users(:joe)
  end

  test "index returns 350 freight contracts by default" do
    get :index

    assert_response :success
    assert_equal 350, assigns(:freight_contracts).size
  end

  test "index returns all freight contracts if set so in params" do
    get :index, limit: :off

    assert_response :success
    assert_equal 351, assigns(:freight_contracts).size
  end

  test "new freight contract can be created with valid attributes" do
    login users(:bob)

    delivery_method = delivery_methods(:lento)
    customer = customers(:stubborn_customer)

    freight_contract = {
      toimitustapa: delivery_method.selite,
      asiakas: customer.tunnus,
      ytunnus: customer.ytunnus,
      rahtisopimus: "13579",
      selite: "kala",
      muumaksaja: "Muumipeikko"
    }

    assert_difference("FreightContract.count") do
      post :create, freight_contract: freight_contract

      assert_redirected_to freight_contracts_url
    end

    freight_contract.each do |key, value|
      assert_equal value, FreightContract.last.send(key), "Attribute #{key} did not get set"
    end
  end

  test "new freight contract cannot be created with invalid attributes" do
    login users(:bob)

    freight_contract = {
      selite: "kissa"
    }

    assert_no_difference("FreightContract.count") do
      post :create, freight_contract: freight_contract
    end
  end
end
