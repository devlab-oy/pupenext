require 'test_helper'

class TermsOfPaymentTest < ActiveSupport::TestCase
  fixtures %w(
    bank_details
    customers
    factorings
    heads
    sales_order/drafts
    sales_order/orders
    terms_of_payments
  )

  setup do
    @eighty_days_net  = terms_of_payments :eighty_days_net
    @hundred_days_net = terms_of_payments :hundred_days_net
    @ninety_days_net  = terms_of_payments :ninety_days_net
    @nordea_factoring = terms_of_payments :factoring
    @not_in_use_net   = terms_of_payments :not_in_use_net
    @seventy_days_net = terms_of_payments :seventy_days_net
    @top              = terms_of_payments :sixty_days_net

    @cust = customers :stubborn_customer
  end

  test 'all fixtures should be valid' do
    assert @eighty_days_net.valid?,  @eighty_days_net.errors.full_messages
    assert @hundred_days_net.valid?, @hundred_days_net.errors.full_messages
    assert @ninety_days_net.valid?,  @ninety_days_net.errors.full_messages
    assert @nordea_factoring.valid?, @nordea_factoring.errors.full_messages
    assert @not_in_use_net.valid?,   @not_in_use_net.errors.full_messages
    assert @seventy_days_net.valid?, @seventy_days_net.errors.full_messages
    assert @top.valid?,              @top.errors.full_messages
  end

  test 'relations' do
    assert_equal 'Nordea', @nordea_factoring.factoring.factoringyhtio
  end

  test 'should be valid date' do
    @top.abs_pvm = '0001-01-01'
    assert @top.valid?

    @top.abs_pvm = nil
    assert @top.valid?

    @top.abs_pvm = ''
    assert @top.valid?

    @top.abs_pvm = '2015-35-35'
    refute @top.valid?

    @top.abs_pvm = '0000-00-00'
    refute @top.valid?
  end

  test 'should be in use' do
    @top.kaytossa = 'E'
    refute @top.valid?, "This terms of payment is used by a customer"

    top_hundred = terms_of_payments(:hundred_days_net)
    top_hundred.kaytossa = 'E'
    refute top_hundred.valid?, "This terms of payment is used by an unfinished sales order"

    top_third = terms_of_payments(:eighty_days_net)
    top_third.kaytossa = 'E'
    refute top_third.valid?, "This terms of payment is used by a undelivered sales order"

    top_fourth = terms_of_payments(:ninety_days_net)
    top_fourth.kaytossa = 'E'
    refute top_fourth.valid?, "This terms of payment is used by a undelivered sales order"

    message = I18n.t 'errors.terms_of_payment.in_use_sales_orders', count: 1
    assert_equal message, top_fourth.errors.full_messages.first
  end

  test 'should get five used and 1 not in use terms of payments' do
    assert_equal 1, TermsOfPayment.not_in_use.count
    assert TermsOfPayment.in_use.count > 5
  end

  test 'should search exact match' do
    params = {
      teksti: '@60 pv netto'
    }

    assert_equal 1, TermsOfPayment.search_like(params).count
  end

  test 'should search by like' do
    assert_equal 1, TermsOfPayment.search_like(kassa_relpvm: '@15').count

    params = { laatija: 'jo', teksti: '60' }
    assert_equal 1, TermsOfPayment.search_like(params).count
  end

  test 'bank detail should be valid' do
    @top.reload.pankkiyhteystiedot = nil
    assert @top.valid?, 'nil is ok, this is an optional attribute'

    @top.reload.pankkiyhteystiedot = @top.company.bank_details.first.id
    assert @top.valid?

    @top.reload.pankkiyhteystiedot = -1
    refute @top.valid?, 'not a valid bank detail id'

    @top.reload.pankkiyhteystiedot = nil
    @top.save
    assert_equal 0, @top.pankkiyhteystiedot, 'nil is saved as zero'
  end

  test 'kateinen attribute enums' do
    options = { "cash" => "p", "debit_card" => "n", "credit_card" => "o", "not_cash" => "" }
    assert_equal options, TermsOfPayment.kateinens # LOL!

    @top = terms_of_payments(:sixty_days_net)
    assert_equal "not_cash", @top.kateinen
    assert_equal "", @top.read_attribute_before_type_cast('kateinen')

    @top.update_attribute(:kateinen, :cash) # can be used with enum names
    assert_equal "cash", @top.reload.kateinen
    assert_equal "p", @top.read_attribute_before_type_cast('kateinen')

    @top.update_attribute(:kateinen, :not_cash) # can be used with enum names
    assert_equal "not_cash", @top.reload.kateinen
    assert_equal "", @top.read_attribute_before_type_cast('kateinen')

    @top.update_attribute(:kateinen, 'o') # can be used with actual values
    assert_equal "credit_card", @top.reload.kateinen
    assert_equal "o", @top.read_attribute_before_type_cast('kateinen')

    @top.update_attribute(:kateinen, 'n') # can be used with actual values
    assert_equal "debit_card", @top.reload.kateinen
    assert_equal "n", @top.read_attribute_before_type_cast('kateinen')

    # Allows only correct values
    assert_raises(ArgumentError) { @top.kateinen = 'x' }
    assert_raises(ArgumentError) { @top.kateinen = 'kissa' }
    assert_raises(ArgumentError) { @top.kateinen = 1 }
  end

  test 'kaytossa attribute enums' do
    options = { "active" => "", "inactive" => "E" }
    assert_equal options, TermsOfPayment.kaytossas # LOL!

    # no need to test enums more here, since we have tested them in "kateinen" enums test
  end

  test 'translations' do
    assert_equal 2, @top.translations.count
    assert_equal ["en", "se"], @top.translated_locales
    assert_equal "60 days net", @top.name_translated(:en)
    assert_equal @top.teksti, @top.name_translated('not_valid_locale')
  end
end
