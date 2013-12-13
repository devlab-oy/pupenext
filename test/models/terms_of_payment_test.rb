require 'test_helper'

class TermsOfPaymentTest < ActiveSupport::TestCase

  def setup
    @top = terms_of_payments(:sixty_days_net)
  end

  test 'all fixtures should be valid' do
    assert @top.valid?
  end

end
