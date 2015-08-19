require "test_helper"

class KeywordTest < ActiveSupport::TestCase
  setup do
    @vat = keywords(:vat)
    @foreign_vat = keywords(:foreign_vat)
  end

  test "fixtures are valid" do
    assert @vat.valid?, @vat.errors.full_messages
    assert @foreign_vat.valid?, @foreign_vat.errors.full_messages
  end

  test 'top translation relation' do
    top_translation = keywords(:top_locale_se)
    assert TermsOfPayment, top_translation.terms_of_payment.class
  end
end
