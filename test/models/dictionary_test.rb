require 'test_helper'

class DictionaryTest < ActiveSupport::TestCase

  def setup
    @hello = dictionaries(:hello)
  end

  test "dictionary model" do
    assert Dictionary.new
  end

  test "fixture is valid" do
    assert @hello.valid?
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
  end

end
