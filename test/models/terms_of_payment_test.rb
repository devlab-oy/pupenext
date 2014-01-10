require 'test_helper'

class TermsOfPaymentTest < ActiveSupport::TestCase

  def setup
    @top = terms_of_payments(:sixty_days_net)
  end

  test 'all fixtures should be valid' do
    assert @top.valid?
  end

  test 'should be valid date' do
    @top.abs_pvm = '0001-01-01'
    assert @top.valid?
    @top.abs_pvm = ''
    assert @top.valid?
  end

  test 'should be invalid date' do
    @top.abs_pvm = 'neko'
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

  test 'should get two terms of payments per used/not_used scopes' do
    assert_equal 1, TermsOfPayment.not_in_use.count
    assert_equal 5, TermsOfPayment.count
  end

end
