require 'test_helper'

class CarrierHelperTest < ActionView::TestCase
  test "returns translated neutraali options valid for collection" do
    assert neutraali_options.is_a? Array

    text = I18n.t 'administration.carriers.neutraali_options.neutral', :fi
    assert_equal text, neutraali_options.first.first
    assert_equal 'neutral', neutraali_options.first.second
  end
end
