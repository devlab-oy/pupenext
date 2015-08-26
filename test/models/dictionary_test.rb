require 'test_helper'

class DictionaryTest < ActiveSupport::TestCase

  setup do
    # RequestStore needs to be cleared here since these tests don't go through the Rack stack
    # where it is usually cleared
    RequestStore.clear!

    @hello = dictionaries(:hello)
  end

  test "dictionary model" do
    assert Dictionary.new
  end

  test "fixture is valid" do
    assert @hello.valid?, @hello.errors.messages
  end

  test "translation works" do
    t = Dictionary.translate("Hei maailma!", "en")
    assert_equal "Hello world!", t, "should translate to english"

    t = Dictionary.translate("HEI MAAILMA!", "en")
    assert_equal "HEI MAAILMA!", t, "translate should be case sensitive"

    t = Dictionary.translate("Hei maailma!", "se")
    assert_equal "Hei maailma!", t, "should return string if translation is nil"

    t = Dictionary.translate("Hei maailma!", "ru")
    assert_equal "Hei maailma!", t, "should return string if translation is empty"

    t = Dictionary.translate("not_in_the_database", "en")
    assert_equal "not_in_the_database", t, "should return string if string is not in database"

    t = Dictionary.translate("Hei maailma!")
    assert_equal "Hei maailma!", t, "return string if no language given"
  end

  test "translated words are saved to current thread" do
    Dictionary.translate("Kirjahylly")

    assert_equal 1, RequestStore.store[:translated_words].length
    assert_includes RequestStore.store[:translated_words], "Kirjahylly"
  end

  test "allowed languages count is correct" do
    assert_equal 7, Dictionary.allowed_languages.count
  end

  test "default language is Finnish" do
    assert_equal "fi", Dictionary.default_language[1]
  end

  test "all languages count is correct" do
    assert_equal 8, Dictionary.all_languages.count
  end

  test "translate raw returns nil if translations are not found" do
    t = Dictionary.translate_raw("Hei maailma!", "en")
    assert_equal "Hello world!", t, "should translate to english when found"

    t = Dictionary.translate_raw("HEI MAAILMA!", "en")
    assert_nil t, "translate should be case sensitive, return nil on not found"

    t = Dictionary.translate_raw("Hei maailma!", "se")
    assert_nil t, "should return nil if translation is nil"

    t = Dictionary.translate_raw("Hei maailma!", "ru")
    assert_nil t, "should return nil if translation is empty"

    t = Dictionary.translate_raw("not_in_the_database", "en")
    assert_nil t, "should return nil if string is not in database"

    t = Dictionary.translate_raw("Hei maailma!", 'fi')
    assert_nil t, "return nil if fi language given"

    assert_raises (ArgumentError) { Dictionary.translate_raw("Hei maailma!") }
  end
end
