require 'test_helper'

class HuutokauppaMailTest < ActiveSupport::TestCase
  setup do
    @mails = Hash.new { |h, k| h[k] = [] }

    mail_dir = Rails.root.join('test', 'assets', 'huutokauppa_emails')

    Dir.foreach(mail_dir) do |item|
      next if item.in?(%w(. .. invalid_customer_info))

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
    @mails.each do |type, mails_of_type|
      mails_of_type.each do |mail|
        assert_equal type, mail.type
      end
    end
  end

  test '#customer_name' do
    assert_equal 'Testi Testit Testitestit', @mails[:offer_accepted][0].customer_name
    assert_equal 'Test-testi Testite',       @mails[:offer_automatically_accepted][0].customer_name
    assert_equal 'Test-testi Testite',       @mails[:purchase_price_paid][0].customer_name

    @mails.values_at(:auction_ended,
                     :bidder_picks_up,
                     :delivery_offer_request,
                     :offer_declined).each do |mails|
      mails.each do |mail|
        assert_nil mail.customer_name
      end
    end
  end

  test '#customer_name returns nil if name is not found' do
    assert_nil HuutokauppaMail.new(huutokauppa_email(:invalid_customer_info)).customer_name
  end

  test '#customer_email' do
    assert_equal 'testit@testi.tes',     @mails[:offer_accepted][0].customer_email
    assert_equal 'te.testite@testi.tes', @mails[:offer_automatically_accepted][0].customer_email
    assert_equal 'te.testite@testi.tes', @mails[:purchase_price_paid][0].customer_email

    @mails.values_at(:auction_ended,
                     :bidder_picks_up,
                     :delivery_offer_request,
                     :offer_declined).each do |mails|
      mails.each do |mail|
        assert_nil mail.customer_email
      end
    end
  end

  test '#customer_phone' do
    assert_equal '+123 45 6789012', @mails[:offer_accepted][0].customer_phone
    assert_equal '+123 45 6789012', @mails[:offer_automatically_accepted][0].customer_phone
    assert_equal '+123 45 6789012', @mails[:purchase_price_paid][0].customer_phone

    @mails.values_at(:auction_ended,
                     :bidder_picks_up,
                     :delivery_offer_request,
                     :offer_declined).each do |mails|
      mails.each do |mail|
        assert_nil mail.customer_phone
      end
    end
  end

  test '#customer_address' do
    assert_equal 'testitestit 12', @mails[:offer_accepted][0].customer_address
    assert_equal 'Testitesti 123', @mails[:offer_automatically_accepted][0].customer_address
    assert_equal 'Testitesti 123', @mails[:purchase_price_paid][0].customer_address

    @mails.values_at(:auction_ended,
                     :bidder_picks_up,
                     :delivery_offer_request,
                     :offer_declined).each do |mails|
      mails.each do |mail|
        assert_nil mail.customer_address
      end
    end
  end
end
