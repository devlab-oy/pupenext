require 'test_helper'

class HuutokauppaMailTest < ActiveSupport::TestCase
  setup do
    @mails = Hash.new { |h, k| h[k] = [] }

    mail_dir = Rails.root.join('test', 'assets', 'huutokauppa_emails')

    Dir.foreach(mail_dir) do |item|
      next if item.in?(%w(. ..))

      key  = item.sub(/_\d\z/, '')
      file = File.read(mail_dir.join(item))

      @mails[key.to_sym] << HuutokauppaMail.new(file)
    end
  end

  test 'files are read correctly' do
    @mails.each do |key, _value|
      refute_empty @mails[key.to_sym]
    end
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

    @mails[:offer_declined].each do |mail|
      assert_equal :offer_declined, mail.type
    end

    @mails[:purchase_price_paid].each do |mail|
      assert_equal :purchase_price_paid, mail.type
    end
  end
end
