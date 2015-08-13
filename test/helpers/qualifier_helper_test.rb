require 'test_helper'

class QualifierHelperTest < ActionView::TestCase
  test "returns translated kaytossa options valid for collection" do
    assert kaytossa_options.is_a? Array

    text = I18n.t 'administration.qualifiers.kaytossa_options.in_use', :fi
    assert_equal text, kaytossa_options.first.first
    assert_equal 'in_use', kaytossa_options.first.second
  end
end
