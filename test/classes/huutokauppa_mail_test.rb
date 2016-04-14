require 'test_helper'

class HuutokauppaMailTest < ActiveSupport::TestCase
  test 'initializes correctly with a raw email source' do
    huutokauppa_mail = nil

    assert_nothing_raised do
      huutokauppa_mail = HuutokauppaMail.new(huutokauppa_email(:automatically_accepted_1))
    end

    assert_equal Mail.new(huutokauppa_email(:automatically_accepted_1)), huutokauppa_mail.mail
  end
end
