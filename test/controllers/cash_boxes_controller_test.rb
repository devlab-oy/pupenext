require 'test_helper'

class CashBoxesControllerTest < ActionController::TestCase

  def setup
    cookies[:pupesoft_session] = "IAOZQQAXYYDWMDBSWOEFSVBBI"
    @cash_box = cash_boxes(:first)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show, id: @cash_box.id
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cash_box.id
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create" do
    request = {
      nimi: 'Kissa',
      kustp: 434,
      toimipaikka: 3,
      kassa: 4001,
      pankkikortti: 4001,
      luottokortti: 4001,
      kateistilitys: 4001,
      kassaerotus: 4001,
      kateisotto: ''
    }

    assert_difference('CashBox.count', 1) do
      post :create, cash_box: request
    end

    assert_redirected_to cash_boxes_path, response.body
  end

test "should not create" do
    request = {
      nimi: 'Kissa',
      kustp: 105,
      toimipaikka: 3,
      kasssa: 3344,
      pankkikortti: nil,
      luottokortti: 2232,
      kateistilitys: 2562,
      kassaerotus: 2562
    }

    assert_no_difference('CashBox.count') do
      post :create, cash_box: request
    end

    assert_template "new", "Template should be new"
  end

  test "should update" do
    request = {
      nimi: 'Koira',
      kustp: 123
    }
    patch :update, id: @cash_box.id, cash_box: request
    assert_redirected_to cash_boxes_path, response.body
  end

end
