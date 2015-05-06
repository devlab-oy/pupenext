require 'test_helper'

class Administration::FiscalYearsControllerTest < ActionController::TestCase
  fixtures %w(fiscal_years)

  setup do
    @fiscal_year = fiscal_years(:one)
    login users(:joe)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fiscal_years)
  end

  test "should get new" do
    login users(:bob)
    get :new
    assert_response :success
  end

  test "should create fiscal_year" do
    login users(:bob)

    params = {
      tilikausi_alku:  '2000-01-01',
      tilikausi_loppu: '2000-12-31'
    }

    assert_difference('FiscalYear.count') do
      post :create, fiscal_year: params
    end

    assert_redirected_to fiscal_years_path
  end

  test 'should no create' do
    login users(:bob)

    params = {
      tilikausi_alku:  '2000-01-41',
      tilikausi_loppu: '2000-12-51'
    }

    assert_no_difference('FiscalYear.count') do
      post :create, fiscal_year: params
    end

    assert_response :success
    assert_not_nil assigns(:fiscal_year)
    assert_template :edit
  end

  test "should show fiscal_year" do
    get :show, id: @fiscal_year
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fiscal_year
    assert_response :success
  end

  test "should update fiscal_year" do
    login users(:bob)

    params = {
      tilikausi_alku:  @fiscal_year.tilikausi_alku,
      tilikausi_loppu: @fiscal_year.tilikausi_loppu
    }

    patch :update, id: @fiscal_year, fiscal_year: params
    assert_redirected_to fiscal_years_path
  end

  test 'should not update' do
    login users(:bob)

    params = {
      tilikausi_alku:  @fiscal_year.tilikausi_alku,
      tilikausi_loppu: ''
    }

    patch :update, id: @fiscal_year, fiscal_year: params
    assert_template :edit
  end
end
