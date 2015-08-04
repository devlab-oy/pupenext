require 'test_helper'

class SumLevelHelperTest < ActionView::TestCase
  test "returns translated kumulatiivinen options valid for collection" do
    assert kumulatiivinen_options.is_a? Array

    text = I18n.t 'administration.sum_levels.kumulatiivinen_options.not_cumulative', :fi
    assert_equal text, kumulatiivinen_options.first.first
  end

  test "returns translated kayttotarkoitus options valid for collection" do
    assert kayttotarkoitus_options.is_a? Array

    text = I18n.t 'administration.sum_levels.kayttotarkoitus_options.normal', :fi
    assert_equal text, kayttotarkoitus_options.first.first
  end
end
