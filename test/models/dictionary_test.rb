require 'test_helper'

class DictionaryTest < ActiveSupport::TestCase

  def setup
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
