require 'test_helper'

class DictionaryTest < ActiveSupport::TestCase
  fixtures %w(dictionaries)

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

end
