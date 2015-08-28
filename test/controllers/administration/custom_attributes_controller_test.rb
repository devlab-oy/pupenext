require 'test_helper'

class Administration::CustomAttributesControllerTest < ActionController::TestCase
  fixtures %w(keywords)

  setup do
    login users(:bob)
    @attribute = keywords(:mysql_alias_1)
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should search index' do
    get :index
    assert_response :success
    assert_template :index
    assert_equal 2, assigns(:attribute_set).count

    get :index, combo_set: 'notfound/search'
    assert_response :success
    assert_template :index
    assert_equal 0, assigns(:attribute_set).count

    get :index, combo_set: 'asiakas/PROSPEKTI'
    assert_response :success
    assert_template :index
    assert_equal 1, assigns(:attribute_set).count
  end

  test 'should get edit' do
    get :edit, id: @attribute.tunnus
    assert_response :success

    get :show, id: @attribute.tunnus
    assert_response :success
  end
end
