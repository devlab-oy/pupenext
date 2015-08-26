require 'test_helper'

class Administration::QualifiersControllerTest < ActionController::TestCase
  fixtures %w(qualifiers)

  setup do
    login users(:bob)
    @qualifier = qualifiers(:project_in_use)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get index with not in use" do
    get :index, not_used: true
    assert_response :success
  end

  test "should get show" do
    get :show, id: @qualifier.id
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create" do
    request = {
      nimi: 'Kissa',
      koodi: '10',
      tyyppi: 'P'
    }

    assert_difference('Qualifier.count', 1) do
      post :create, qualifier: request
    end

    assert_equal 'P', Qualifier.last.tyyppi

    assert_redirected_to qualifiers_path, response.body
  end

  test "should not create" do
    request = {
      nimi: '',
      tyyppi: 'K'
    }

    assert_no_difference('Qualifier.count') do
      post :create, qualifier: request
    end

    assert_template "edit", "Template should be edit"
  end

  test "should get edit" do
    get :edit, id: @qualifier.id
    assert_response :success
  end

  test "should get update" do
    request = {
      nimi: 'Koira',
      koodi: 'J'
    }

    patch :update, id: @qualifier.id, qualifier: request
    assert_redirected_to qualifiers_path
  end

  test "should not update" do
    request = {
      tyyppi: 'not_valid'
    }

    patch :update, id: @qualifier.id, qualifier: request
    assert_template "edit", "Template should be edit"
  end
end
