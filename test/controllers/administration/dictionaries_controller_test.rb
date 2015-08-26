require "test_helper"

class Administration::DictionariesControllerTest < ActionController::TestCase
  setup do
    login users(:joe)

    @hello = dictionaries(:hello)
    @car = dictionaries(:car)
    @new_car = dictionaries(:new_car)
  end

  test "index doesn't return anything when accessed without searching" do
    get :index

    assert_response :success
    assert_equal 0, assigns(:dictionaries).count
  end

  test "index doesn't return anything and notifies when no language is specified when searching" do
    get :index, { commit: "Hae" }

    assert_response :success
    assert_equal 0, assigns(:dictionaries).count
    assert_equal "Valitse käännettävä kieli", flash[:alert]
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
    get :index, { languages: [:en], search: { language: "fi", keyword: "auto\r\nmaailma " } }

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

    patch :bulk_update, dictionaries: dictionaries

    assert_response :success

    assert_equal "Fish", @hello.reload.en
    assert_equal "Fisk", @hello.reload.se

    assert_equal "Cat", @car.reload.en
    assert_equal "Kat", @car.reload.se

    assert_equal "Sanakirja päivitetty", flash[:notice]
  end

  test "shows only untranslated rows when untranslated is selected" do
    get :index, { languages: [:se, :no], untranslated: "true" }

    assert_response :success
    assert_equal 1, assigns(:dictionaries).count
  end

  test "translated dictionaries are filtered out after update" do
    dictionaries = {
      @hello.id.to_s => {
        se: "Fisk"
      }
    }

    patch :bulk_update, { languages: [:se], untranslated: "true", dictionaries: dictionaries }

    assert_response :success
    assert_equal 0, assigns(:dictionaries).count
  end

  test "Translations for all languages can be updated" do
    languages = {
      se: "Ruotsi",
      no: "Norja",
      en: "Englanti",
      de: "Saksa",
      dk: "Tanska",
      ru: "Venäjä",
      ee: "Viro"
    }

    dictionaries = {
      @new_car.id.to_s => languages
    }

    patch :bulk_update, dictionaries: dictionaries

    languages.each do |key, value|
      dictionary = @new_car.reload
      assert_equal value, dictionary.send(key)
    end
  end

  test "Other than translations cannot be updated" do
    old_values = {
      kysytty: @car.kysytty,
      synkronoi: @car.synkronoi
    }

    params = {
      kysytty: 123,
      synkronoi: "U"
    }

    dictionaries = {
      @car.id.to_s => params
    }

    patch :bulk_update, dictionaries: dictionaries

    old_values.each do |key, value|
      dictionary = @car.reload
      assert_equal value, dictionary.send(key)
    end
  end
end
