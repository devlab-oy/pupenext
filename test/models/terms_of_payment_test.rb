require 'test_helper'

class TermsOfPaymentTest < ActiveSupport::TestCase

  def setup
    @top = terms_of_payments(:sixty_days_net)
    @cust = customers(:stubborn_customer)
  end

  test 'all fixtures should be valid' do
    assert @top.valid?, @top.errors.full_messages.inspect
  end

  test 'should be valid date' do
    @top.abs_pvm = '0001-01-01'
    assert @top.valid?, @top.errors.full_messages

    @top.abs_pvm = nil
    assert @top.valid?, @top.errors.full_messages
  end

  test 'should not be valid date' do
    skip
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

    @top_fourth = terms_of_payments(:ninty_days_net)
    @top_fourth.kaytossa = 'E'
    refute @top_fourth.valid?, "This terms of payment is used by a undelivered sales order"
  end

  test 'should get five used and 1 not in use terms of payments' do
    assert_equal 1, TermsOfPayment.not_in_use.count
    assert_equal 5, TermsOfPayment.count
  end

  test 'should search exact match' do
    params = {
      teksti: '@60 pv netto'
    }

    assert_equal 1, TermsOfPayment.search_like(params).count
  end

  test 'should search by like' do
    params = {
      kassa_relpvm: 15
    }

    assert_equal 1, TermsOfPayment.search_like(params).count

    params = {
      kassa_relpvm: 15,
      teksti: '60'
    }

    assert_equal 1, TermsOfPayment.search_like(params).count
  end

end
