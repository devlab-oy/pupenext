require 'test_helper'

class Administration::BankAccountsControllerTest < ActionController::TestCase
  fixtures %w(bank_accounts accounts)

  setup do
    login users(:joe)

    @ba = bank_accounts(:acme_account)
    @acc1 = accounts(:account_200)
    @acc2 = accounts(:account_210)
    @acc3 = accounts(:account_220)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_template :index
  end

  test "should get new" do
    login users(:bob)

    get :new
    assert_response :success
    assert_template :edit
  end

  test "should get edit" do
    get :edit, id: @ba.tunnus
    assert_response :success
    assert_template :edit
  end

  test "creates bank account with valid parameters" do
    login users(:bob)

    params = {
      kaytossa: "active",
      nimi: "Keijo",
      iban: "FI3715903000000776",
      bic: "DABAFIHH",
      valkoodi: "71",
      factoring: "factoring_enabled",
      asiakastunnus: "kala",
      maksulimitti: 10,
      tilinylitys: "limit_override_allowed",
      hyvak: "kissa",
      oletus_kulutili: @acc1.tilino,
      oletus_kustp: 1,
      oletus_kohde: 2,
      oletus_projekti: 3,
      oletus_rahatili: @acc2.tilino,
      oletus_selvittelytili: @acc3.tilino
    }

    assert_difference('BankAccount.count', 1) do
      post :create, bank_account: params
    end

    params.each do |attribute_key, attribute_value|
      assert_equal attribute_value, BankAccount.last.send(attribute_key),
                   "Attribute #{attribute_key} did not get set"
    end

    assert_redirected_to bank_accounts_path
  end

  test "does not create bank account with invalid parameters" do
    login users(:bob)

    params = { iban: @ba.iban }

    assert_no_difference('BankAccount.count') do
      post :create, bank_account: params
      assert_template :edit
    end
  end

  test "updates with valid parameters" do
    login users(:bob)

    params = { nimi: "Kermitti" }

    patch :update, id: @ba.tunnus, bank_account: params
    assert_redirected_to bank_accounts_path
  end

  test "does not update with invalid parameters" do
    login users(:bob)

    params = { bic: "kala", iban: "kissa1" }

    patch :update, id: @ba.tunnus, bank_account: params
    assert_template :edit
  end

end
