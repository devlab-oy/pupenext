require 'test_helper'

class HuutokauppaMailTest < ActiveSupport::TestCase
  setup do
    @mails = {
      offer_automatically_accepted: [
        HuutokauppaMail.new(huutokauppa_email(:offer_automatically_accepted_1))
      ],
      delivery_offer_request: [
        HuutokauppaMail.new(huutokauppa_email(:delivery_offer_request_1))
      ],
      delivery_ordered: [
        HuutokauppaMail.new(huutokauppa_email(:delivery_ordered_1))
      ],
      auction_ended: [
        HuutokauppaMail.new(huutokauppa_email(:auction_ended_1))
      ],
      offer_accepted: [
        HuutokauppaMail.new(huutokauppa_email(:offer_accepted_1))
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

    @mails[:delivery_offer_request].each do |mail|
      assert_equal :delivery_offer_request, mail.type
    end

    @mails[:delivery_ordered].each do |mail|
      assert_equal :delivery_ordered, mail.type
    end

    @mails[:auction_ended].each do |mail|
      assert_equal :auction_ended, mail.type
    end

    @mails[:offer_accepted].each do |mail|
      assert_equal :offer_accepted, mail.type
    end
  end
end
