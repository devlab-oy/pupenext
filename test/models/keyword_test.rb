require "test_helper"

class KeywordTest < ActiveSupport::TestCase
  fixtures %w(keywords)

  setup do
    @vat = keywords(:vat)
    @foreign_vat = keywords(:foreign_vat)
    @top_translation = keywords(:top_locale_se)
    @dm_translation = keywords(:deliverymethod_locale_en)
  end

  test "fixtures are valid" do
    assert @vat.valid?, @vat.errors.full_messages
    assert @foreign_vat.valid?, @foreign_vat.errors.full_messages
    assert @top_translation.valid?, @top_translation.errors.full_messages
    assert @dm_translation.valid?, @dm_translation.errors.full_messages
    assert keywords(:top_locale_en).valid?
    assert keywords(:deliverymethod_locale_en).valid?
  end

  test 'translation relation' do
    assert TermsOfPayment, @top_translation.terms_of_payment.class
    assert DeliveryMethod, @dm_translation.delivery_method.class
  end

  test 'translation scope' do
    # translations :kieli is scoped [:yhtio, :selite]
    new_translation = @top_translation.dup
    dm_new_translation = @dm_translation.dup
    refute new_translation.valid?
    refute dm_new_translation.valid?

    error_message = [:kieli, I18n.t('errors.messages.taken')]
    assert_equal error_message, new_translation.errors.first
    assert_equal error_message, dm_new_translation.errors.first

    # changing yhtio should make it valid
    new_translation.yhtio = 'esto'
    dm_new_translation.yhtio = 'esto'
    assert new_translation.valid?
    assert dm_new_translation.valid?

    # changing selite should make it valid
    new_translation = @top_translation.dup
    new_translation.selite = 324
    assert new_translation.valid?

    dm_new_translation = @dm_translation.dup
    dm_new_translation.selite = 324
    assert dm_new_translation.valid?

    # or changing kieli should make it valid
    new_translation = @top_translation.dup
    new_translation.kieli = 'no'
    assert new_translation.valid?

    dm_new_translation = @dm_translation.dup
    dm_new_translation.kieli = 'no'
    assert dm_new_translation.valid?
  end
end
