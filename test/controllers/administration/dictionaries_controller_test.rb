require "test_helper"

class Administration::DictionariesControllerTest < ActionController::TestCase
  setup do
    login users(:joe)
  end

  test "index doesn't return anything unless at least one language is specified" do
    get :index

    assert_response :success
    assert_equal 0, assigns(:dictionaries).count
  end

  test "index doesn't return anything if an empty languages array is specified" do
    get :index, languages: []

    assert_response :success
    assert_equal 0, assigns(:dictionaries).count
  end

  test "index returns all dictionaries when one language is specified" do
    get :index, languages: [:en]

    assert_response :success
    assert_equal 2, assigns(:dictionaries).count
  end

  test "index doesn't return anything if an invalid language is specified" do
    get :index, languages: [:kala]

    assert_response :success
    assert_equal 0, assigns(:dictionaries).count
  end

  test "index returns translations matching search criteria in Finnish" do
    get :index, { languages: [:en], search: { language: "fi", keyword: "auto" } }

    assert_response :success
    assert_equal 1, assigns(:dictionaries).count
    assert_equal "Auto", assigns(:dictionaries).first.fi
  end

  test "index returns translations matching search criteria in English" do
    get :index, { languages: [:en], search: { language: "en", keyword: "car" } }

    assert_response :success
    assert_equal 1, assigns(:dictionaries).count
    assert_equal "Auto", assigns(:dictionaries).first.fi
  end
end
