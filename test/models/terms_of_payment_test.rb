require 'test_helper'

class TermsOfPaymentTest < ActiveSupport::TestCase
  fixtures %w(terms_of_payments customers bank_details factorings)

  def setup
    @top = terms_of_payments(:sixty_days_net)
    @cust = customers(:stubborn_customer)
  end

  test 'all fixtures should be valid' do
    assert @top.valid?, @top.errors.full_messages.inspect
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

    @top_hundred = terms_of_payments(:hundred_days_net)
    @top_hundred.kaytossa = 'E'
    refute @top_hundred.valid?, "This terms of payment is used by an unfinished sales order"

    @top_third = terms_of_payments(:eighty_days_net)
    @top_third.kaytossa = 'E'
    refute @top_third.valid?, "This terms of payment is used by a undelivered sales order"

    @top_fourth = terms_of_payments(:ninety_days_net)
    @top_fourth.kaytossa = 'E'
    refute @top_fourth.valid?, "This terms of payment is used by a undelivered sales order"
  end

  test 'should get five used and 1 not in use terms of payments' do
    assert_equal 1, TermsOfPayment.not_in_use.count
    assert_equal 5, TermsOfPayment.in_use.count
  end

  test 'should search exact match' do
    params = {
      teksti: '@60 pv netto'
    }

    assert_equal 1, TermsOfPayment.search_like(params).count
  end

  test 'should get one or more factoring options' do
    top = terms_of_payments(:hundred_days_net)
    assert_not_equal 0, top.factoring_options.count
  end

  test 'should search by like' do
    assert_equal 1, TermsOfPayment.search_like(kassa_relpvm: '@15').count

    params = { laatija: 'jo', osamaksuehto1: '0', teksti: '60' }
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
end
