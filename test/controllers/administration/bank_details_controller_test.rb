require 'test_helper'

class Administration::BankDetailsControllerTest < ActionController::TestCase
  setup do
    @one = bank_details(:one)
    login users(:joe)
  end

  test "index returns all bank details" do
    get :index

    assert_response :success
    assert_equal 1, assigns(:bank_details).count
  end

  test "bank detail can be created with valid attributes" do
    login users(:bob)

    params = {
      nimitys: "Test details",
      pankkinimi1: "Bank 1",
      pankkitili1: "1234",
      pankkiiban1: "FI1234",
      pankkiswift1: "ABCDE",
      pankkinimi2: "Bank 2",
      pankkitili2: "12345",
      pankkiiban2: "FI12345",
      pankkiswift2: "ABCDEF",
      pankkinimi3: "Bank 3",
      pankkitili3: "123456",
      pankkiiban3: "FI123456",
      pankkiswift3: "ABCDEFG",
      viite: "SE"
    }

    assert_difference("BankDetail.count", 1) do
      post :create, bank_detail: params

      assert_redirected_to bank_details_url
    end


    params.each do |attribute, value|
      assert_equal value, BankDetail.last.send(attribute), "Attribute #{attribute} did not get set"
    end
  end

  test "bank details cannot be created with invalid attributes" do
    login users(:bob)

    params = { pankkinimi1: "Bank 1" }

    assert_no_difference("BankDetail.count") do
      post :create, bank_detail: params

      assert_template :new
    end
  end

  test "bank details can be updated with valid attributes" do
    login users(:bob)

    new_name = "New name"

    patch :update, id: @one.id, bank_detail: { nimitys: new_name }

    assert_redirected_to bank_details_url
    assert_equal new_name, @one.reload.nimitys
  end
end
