require 'test_helper'

class Administration::CashBoxesControllerTest < ActionController::TestCase

  def setup
    login users(:bob)
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
      kassa: 110,
      pankkikortti: 120,
      luottokortti: 130,
      kateistilitys: 140,
      kassaerotus: 150,
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
      kasssa: 160,
      pankkikortti: nil,
      luottokortti: 170,
      kateistilitys: 180,
      kassaerotus: 190
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
