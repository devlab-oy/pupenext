require "test_helper"

class KeywordTest < ActiveSupport::TestCase
  setup do
    @vat = keywords(:vat)
    @foreign_vat = keywords(:foreign_vat)
    @top_translation = keywords(:top_locale_se)
  end

  test "fixtures are valid" do
    assert @vat.valid?, @vat.errors.full_messages
    assert @foreign_vat.valid?, @foreign_vat.errors.full_messages
    assert @top_translation.valid?, @top_translation.errors.full_messages
    assert keywords(:top_locale_en).valid?
  end

  test 'top translation relation' do
    assert TermsOfPayment, @top_translation.terms_of_payment.class
  end
end
