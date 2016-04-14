require 'test_helper'

class HuutokauppaMailTest < ActiveSupport::TestCase
  setup do
    @mails = {
      offer_automatically_accepted: [
        HuutokauppaMail.new(huutokauppa_email(:offer_automatically_accepted_1))
      ]
    }
  end

  test 'initializes correctly with a raw email source' do
    huutokauppa_mail = nil

    assert_nothing_raised do
      huutokauppa_mail = HuutokauppaMail.new(huutokauppa_email(:offer_automatically_accepted_1))
    end

    assert_equal Mail.new(huutokauppa_email(:offer_automatically_accepted_1)), huutokauppa_mail.mail
  end

  test '#type' do
    @mails[:offer_automatically_accepted].each do |mail|
      assert_equal :offer_automatically_accepted, mail.type
    end
  end
end
