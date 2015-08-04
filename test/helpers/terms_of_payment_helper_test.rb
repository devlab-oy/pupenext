require 'test_helper'

class TermsOfPaymentHelperTest < ActionView::TestCase
  test "returns translated cash options valid for collection" do
    assert cash_options.is_a? Array

    text = I18n.t 'administration.terms_of_payments.cash_options.not_cash', :fi
    assert_equal text, cash_options.first.first
  end

  test "returns translated in use options valid for collection" do
    assert in_use_options.is_a? Array

    text = I18n.t 'administration.terms_of_payments.in_use_options.active', :fi
    assert_equal text, in_use_options.first.first
  end
end
