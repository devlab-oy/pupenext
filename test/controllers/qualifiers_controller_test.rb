require 'test_helper'

class QualifiersControllerTest < ActionController::TestCase

  def setup
    cookies[:pupesoft_session] = "IAOZQQAXYYDWMDBSWOEFSVBBI"
    @qualifier = qualifiers(:first)
  end

  test "should get index" do
    get :index
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
      tyyppi: 'K'
    }

    assert_difference('Qualifier.count', 1) do
      post :create, qualifier: request
    end

    assert_redirected_to qualifiers_path, response.body
  end

  test "should not create" do

    request = {
      nimi: 'Kissa',
      koodi: '',
      tyyppi: 'K'
    }

    assert_no_difference('Qualifier.count') do
      post :create, qualifier: request
    end

    assert_template "new", "Template should be new"
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
      nimi: ''
    }

    patch :update, id: @qualifier.id, qualifier: request
    assert_template "edit", "Template should be edit"
  end
end
