require 'test_helper'

class Administration::RevenueExpendituresControllerTest < ActionController::TestCase
  fixtures %w(keywords)

  setup do
    login users(:bob)
    @data = keywords(:weekly_alternative_expenditure_one)
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @data.tunnus
    assert_response :success

    get :show, id: @data.tunnus
    assert_response :success
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create keyword' do
    params = {
      selite: '201536',
      selitetark: 'Palkat',
      selitetark_2: 1000,
    }

    assert_difference('Keyword::RevenueExpenditure.count') do
      post :create, revenue_expenditure: params
    end

    assert_redirected_to revenue_expenditures_path
  end

  test 'should not create keyword' do
    params = {
      selite: '201536',
      selitetark: '',
      selitetark_2: 'kek',
    }

    assert_no_difference('Keyword::RevenueExpenditure.count') do
      post :create, revenue_expenditure: params
      assert_template :edit
    end
  end

  test 'should update keyword' do
    params = { selitetark: 'Here comes the boom' }

    patch :update, id: @data.id, revenue_expenditure: params
    assert_redirected_to revenue_expenditures_path
  end

  test 'should not update keyword' do
    params = { selitetark: '' }

    patch :update, id: @data.id, revenue_expenditure: params
    assert_template :edit
  end

  test 'should delete keyword' do
    assert_difference('Keyword::RevenueExpenditure.count', -1) do
      delete :destroy, id: @data.id
    end

    assert_redirected_to revenue_expenditures_path
  end
end
