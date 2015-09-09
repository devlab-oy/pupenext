require "test_helper"

class KeywordTest < ActiveSupport::TestCase
  fixtures %w(keywords)

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
    assert keywords(:group_1).valid?
  end

  test 'top translation relation' do
    assert TermsOfPayment, @top_translation.terms_of_payment.class
  end

  test 'top translation scope' do
    # translations :kieli is scoped [:yhtio, :selite]
    new_translation = @top_translation.dup
    refute new_translation.valid?

    error_message = [:kieli, I18n.t('errors.messages.taken')]
    assert_equal error_message, new_translation.errors.first

    # changing yhtio should make it valid
    new_translation.yhtio = 'esto'
    assert new_translation.valid?

    # changing selite should make it valid
    new_translation = @top_translation.dup
    new_translation.selite = 324
    assert new_translation.valid?

    # or changing kieli should make it valid
    new_translation = @top_translation.dup
    new_translation.kieli = 'no'
    assert new_translation.valid?
  end
end
