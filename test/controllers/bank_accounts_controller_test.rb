require 'test_helper'

class BankAccountsControllerTest < ActionController::TestCase

  def setup
    cookies[:pupesoft_session] = users(:joe).session
    @ba = bank_accounts(:acme_account)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_template 'index', 'Template should be index'
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_template 'new', 'Template should be new'
  end

  test "should get edit" do
    get :edit, id: @ba.tunnus
    assert_response :success
    assert_template 'edit', 'Template should be edit'
  end

  test "should create" do
    params = {
      nimi: 'Keijo',
      pankki: 'Rolfs Bank',
      iban: 'FI37-1590-3000-0007-76',
      bic: 'DABAFIHH',
      oletus_kulutili: '1000',
      oletus_rahatili: '2000',
      oletus_selvittelytili: '3000'
    }

    assert_difference('BankAccount.count', 1) do
      patch :create, bank_account: params
    end
    assert_redirected_to bank_accounts_path
  end

  test "should not create" do
    params = { iban: @ba.iban }

    assert_no_difference('BankAccount.count') do
      patch :create, bank_account: params
      assert_template 'new', 'Template should be new'
    end
  end

  test "should update" do
     params = { nimi: "Kermitti" }

     patch :update, id: @ba.tunnus, bank_account: params
     assert_redirected_to bank_accounts_path
     assert_equal 'Bank account was successfully updated.', flash.notice
  end

  test "should not update" do
    params = { tilino: nil, bic: nil, iban: nil }

    patch :update, id: @ba.tunnus, bank_account: params
    assert_template 'edit', 'Template should be edit'
    assert_equal nil, flash.notice
  end

end
