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
    refute @top.valid?
  end

end
