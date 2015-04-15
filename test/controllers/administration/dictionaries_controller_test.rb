require "test_helper"

class Administration::DictionariesControllerTest < ActionController::TestCase
  setup do
    login users(:joe)

    @hello = dictionaries(:hello)
    @car = dictionaries(:car)
    @new_car = dictionaries(:new_car)
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
    assert_equal 3, assigns(:dictionaries).count
  end

  test "index doesn't return anything if an invalid language is specified" do
    get :index, languages: [:kala]

    assert_response :success
    assert_equal 0, assigns(:dictionaries).count
  end

  test "index returns translations matching search criteria in Finnish" do
    get :index, { languages: [:en], search: { language: "fi", keyword: "auto" } }

    assert_response :success
    assert_equal 2, assigns(:dictionaries).count
  end

  test "index returns translations matching search criteria in English" do
    get :index, { languages: [:en], search: { language: "en", keyword: "car" } }

    assert_response :success
    assert_equal 2, assigns(:dictionaries).count
  end

  test "index returns translations with multiple search keywords" do
    get :index, { languages: [:en], search: { language: "fi", keyword: "auto\nmaailma" } }

    assert_response :success
    assert_equal 3, assigns(:dictionaries).count
  end

  test "index doesn't return anything with an invalid search language" do
    get :index, { languages: [:en], search: { language: "kala", keyword: "car" } }

    assert_response :success
    assert_equal 0, assigns(:dictionaries).count
  end

  test "index returns translations matching strict search criteria" do
    get :index, { languages: [:en], search: { language: "fi", keyword: "Auto", strict: "true" } }

    assert_response :success
    assert_equal 1, assigns(:dictionaries).count
  end

  test "dictionaries can be updated with correct values" do
    dictionaries = {
      @hello.id.to_s => {
        en: "Fish",
        se: "Fisk"
      },
      @car.id.to_s => {
        en: "Cat",
        se: "Kat"
      }
    }

    post :create, dictionaries: dictionaries

    assert_response :success

    assert_equal "Fish", @hello.reload.en
    assert_equal "Fisk", @hello.reload.se

    assert_equal "Cat", @car.reload.en
    assert_equal "Kat", @car.reload.se
  end

  test "shows only untranslated rows when untranslated is selected" do
    get :index, { languages: [:se, :no], untranslated: "true" }

    assert_response :success
    assert_equal 1, assigns(:dictionaries).count
  end
end
