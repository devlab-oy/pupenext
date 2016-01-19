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
    assert_equal 0, assigns(:attribute_set).count

    get :index, table_alias_set: 'notfound+search'
    assert_response :success
    assert_template :index
    assert_equal 0, assigns(:attribute_set).count

    get :index, table_alias_set: 'asiakas+PROSPEKTI'
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

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create attribute' do
    params = {
      database_field: 'toimi.nimi',
      label: 'Toimittajan nimi',
      set_name: 'MINISET',
      default_value: 'Bob',
      help_text: 'Ongelmatilanteessa soita jonnekin',
      visibility: 'visible',
      required: 'optional',
    }

    assert_difference("Keyword::CustomAttribute.count") do
      post :create, custom_attribute: params
    end

    assert_redirected_to custom_attributes_path(table_alias_set: "toimi+MINISET")
  end

  test 'should not create attribute' do
    params = {
      visibility: 'visible',
      required: 'optional',
    }

    assert_no_difference("Keyword::CustomAttribute.count") do
      post :create, custom_attribute: params
      assert_template :edit
    end
  end

  test 'should update attribute' do
    params = { label: "Foobar" }

    patch :update, id: @attribute.id, custom_attribute: params
    assert_redirected_to custom_attributes_path(table_alias_set: @attribute.alias_set_name)
  end

  test 'should not update attribute' do
    params = { label: '' }

    patch :update, id: @attribute.id, custom_attribute: params
    assert_template :edit
  end

  test "should delete attribute" do
    assert_difference("Keyword::CustomAttribute.count", -1) do
      delete :destroy, id: @attribute.id
    end

    assert_redirected_to custom_attributes_path(table_alias_set: @attribute.alias_set_name)
  end
end
