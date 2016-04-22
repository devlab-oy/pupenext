require 'test_helper'

class HuutokauppaMailTest < ActiveSupport::TestCase
  fixtures %w(
    customers
    keyword/customer_categories
    keyword/customer_subcategories
    keywords
    sales_order/drafts
  )

  setup do
    # setup all emails
    @auction_ended                = HuutokauppaMail.new huutokauppa_email(:auction_ended_1)
    @bidder_picks_up              = HuutokauppaMail.new huutokauppa_email(:bidder_picks_up_1)
    @delivery_offer_request       = HuutokauppaMail.new huutokauppa_email(:delivery_offer_request_1)
    @delivery_ordered             = HuutokauppaMail.new huutokauppa_email(:delivery_ordered_1)
    @invalid_customer_info        = HuutokauppaMail.new huutokauppa_email(:invalid_customer_info)
    @offer_accepted               = HuutokauppaMail.new huutokauppa_email(:offer_accepted_1)
    @offer_automatically_accepted = HuutokauppaMail.new huutokauppa_email(:offer_automatically_accepted_1)
    @offer_declined               = HuutokauppaMail.new huutokauppa_email(:offer_declined_1)
    @purchase_price_paid          = HuutokauppaMail.new huutokauppa_email(:purchase_price_paid_1)

    @emails_without_customer_info = [
      @auction_ended,
      @bidder_picks_up,
      @delivery_offer_request,
      @delivery_ordered,
      @offer_declined
    ]

    @emails_without_delivery_info = [
      @auction_ended,
      @bidder_picks_up,
      @offer_accepted,
      @offer_automatically_accepted,
      @offer_declined,
      @purchase_price_paid
    ]
  end

  test 'initializes correctly with a raw email source' do
    huutokauppa_mail = nil
    file = huutokauppa_email(:offer_automatically_accepted_1)

    assert_nothing_raised do
      huutokauppa_mail = HuutokauppaMail.new(file)
    end

    assert_equal Mail.new(file), huutokauppa_mail.mail
  end

  test '#type' do
    assert_equal :auction_ended,                @auction_ended.type
    assert_equal :bidder_picks_up,              @bidder_picks_up.type
    assert_equal :delivery_offer_request,       @delivery_offer_request.type
    assert_equal :delivery_ordered,             @delivery_ordered.type
    assert_equal :offer_accepted,               @invalid_customer_info.type
    assert_equal :offer_accepted,               @offer_accepted.type
    assert_equal :offer_automatically_accepted, @offer_automatically_accepted.type
    assert_equal :offer_declined,               @offer_declined.type
    assert_equal :purchase_price_paid,          @purchase_price_paid.type
  end

  test '#customer_name' do
    assert_equal 'Testi Testit Testitestit', @offer_accepted.customer_name
    assert_equal 'Test-testi Testite',       @offer_automatically_accepted.customer_name
    assert_equal 'Test-testi Testite',       @purchase_price_paid.customer_name

    @emails_without_customer_info.each do |mail|
      assert_nil mail.customer_name
    end
  end

  test '#customer_name returns nil if name is not found' do
    assert_nil @invalid_customer_info.customer_name
  end

  test '#customer_email' do
    assert_equal 'testit@testi.tes',     @offer_accepted.customer_email
    assert_equal 'te.testite@testi.tes', @offer_automatically_accepted.customer_email
    assert_equal 'te.testite@testi.tes', @purchase_price_paid.customer_email

    @emails_without_customer_info.each do |mail|
      assert_nil mail.customer_email
    end
  end

  test '#customer_phone' do
    assert_equal '+123 45 6789012', @offer_accepted.customer_phone
    assert_equal '+123 45 6789012', @offer_automatically_accepted.customer_phone
    assert_equal '+123 45 6789012', @purchase_price_paid.customer_phone

    @emails_without_customer_info.each do |mail|
      assert_nil mail.customer_phone
    end
  end

  test '#customer_address' do
    assert_equal 'testitestit 12', @offer_accepted.customer_address
    assert_equal 'Testitesti 123', @offer_automatically_accepted.customer_address
    assert_equal 'Testitesti 123', @purchase_price_paid.customer_address

    @emails_without_customer_info.each do |mail|
      assert_nil mail.customer_address
    end
  end

  test '#customer_postcode' do
    assert_equal '12345', @offer_accepted.customer_postcode
    assert_equal '23456', @offer_automatically_accepted.customer_postcode
    assert_equal '12345', @purchase_price_paid.customer_postcode

    @emails_without_customer_info.each do |mail|
      assert_nil mail.customer_postcode
    end
  end

  test '#customer_city' do
    assert_equal 'Testi',      @offer_accepted.customer_city
    assert_equal 'Testitesti', @offer_automatically_accepted.customer_city
    assert_equal 'Testitesti', @purchase_price_paid.customer_city

    @emails_without_customer_info.each do |mail|
      assert_nil mail.customer_city
    end
  end

  test '#customer_country' do
    assert_equal 'Suomi', @offer_accepted.customer_country
    assert_equal 'Suomi', @offer_automatically_accepted.customer_country
    assert_equal 'Suomi', @purchase_price_paid.customer_country

    @emails_without_customer_info.each do |mail|
      assert_nil mail.customer_country
    end
  end

  test '#delivery_name' do
    assert_equal 'Test-testi Testite',         @delivery_offer_request.delivery_name
    assert_equal 'Test-testi testit Testites', @delivery_ordered.delivery_name

    @emails_without_delivery_info.each do |mail|
      assert_nil mail.delivery_name
    end
  end

  test '#delivery_address' do
    assert_equal 'Testitesti 123', @delivery_offer_request.delivery_address
    assert_equal 'Testitest 1',    @delivery_ordered.delivery_address

    @emails_without_delivery_info.each do |mail|
      assert_nil mail.delivery_address
    end
  end

  test '#delivery_postcode' do
    assert_equal '12345', @delivery_offer_request.delivery_postcode
    assert_equal '23456', @delivery_ordered.delivery_postcode

    @emails_without_delivery_info.each do |mail|
      assert_nil mail.delivery_postcode
    end
  end

  test '#delivery_city' do
    assert_equal 'Testitesti',   @delivery_offer_request.delivery_city
    assert_equal 'Testitestite', @delivery_ordered.delivery_city

    @emails_without_delivery_info.each do |mail|
      assert_nil mail.delivery_city
    end
  end

  test '#delivery_phone' do
    assert_equal '+123 45 6789012', @delivery_offer_request.delivery_phone
    assert_equal '123 4567890',     @delivery_ordered.delivery_phone

    @emails_without_delivery_info.each do |mail|
      assert_nil mail.delivery_phone
    end
  end

  test '#delivery_email' do
    assert_equal 'te.testite@testi.tes',                @delivery_offer_request.delivery_email
    assert_equal 'test-testi.testites@te-testitest.te', @delivery_ordered.delivery_email

    @emails_without_delivery_info.each do |mail|
      assert_nil mail.delivery_email
    end
  end

  test '#delivery_price_with_vat' do
    assert_equal 0.0,   @bidder_picks_up.delivery_price_with_vat
    assert_equal 17.95, @delivery_ordered.delivery_price_with_vat

    assert_nil @auction_ended.delivery_price_with_vat
    assert_nil @delivery_offer_request.delivery_price_with_vat
    assert_nil @offer_accepted.delivery_price_with_vat
    assert_nil @offer_automatically_accepted.delivery_price_with_vat
    assert_nil @offer_declined.delivery_price_with_vat
    assert_nil @purchase_price_paid.delivery_price_with_vat
  end

  test '#delivery_vat_percent' do
    assert_equal 24, @bidder_picks_up.delivery_vat_percent
    assert_equal 24, @delivery_ordered.delivery_vat_percent

    assert_nil @auction_ended.delivery_vat_percent
    assert_nil @delivery_offer_request.delivery_vat_percent
    assert_nil @offer_accepted.delivery_vat_percent
    assert_nil @offer_automatically_accepted.delivery_vat_percent
    assert_nil @offer_declined.delivery_vat_percent
    assert_nil @purchase_price_paid.delivery_vat_percent
  end

  test '#delivery_vat_amount' do
    assert_equal 0.0,  @bidder_picks_up.delivery_vat_amount
    assert_equal 3.48, @delivery_ordered.delivery_vat_amount

    assert_nil @auction_ended.delivery_vat_amount
    assert_nil @delivery_offer_request.delivery_vat_amount
    assert_nil @offer_accepted.delivery_vat_amount
    assert_nil @offer_automatically_accepted.delivery_vat_amount
    assert_nil @offer_declined.delivery_vat_amount
    assert_nil @purchase_price_paid.delivery_vat_amount
  end

  test '#total_price_with_vat' do
    assert_equal 210.8,  @bidder_picks_up.total_price_with_vat
    assert_equal 129.55, @delivery_ordered.total_price_with_vat
    assert_equal 806.0,  @auction_ended.total_price_with_vat
    assert_equal 372.0,  @delivery_offer_request.total_price_with_vat
    assert_equal 824.6,  @offer_accepted.total_price_with_vat
    assert_equal 372.0,  @offer_automatically_accepted.total_price_with_vat
    assert_equal 62.0,   @offer_declined.total_price_with_vat
    assert_equal 372.0,  @purchase_price_paid.total_price_with_vat
  end

  test '#auction_id' do
    assert_equal '279590', @auction_ended.auction_id
    assert_equal '285888', @bidder_picks_up.auction_id
    assert_equal '270265', @delivery_offer_request.auction_id
    assert_equal '274472', @delivery_ordered.auction_id
    assert_equal '277075', @offer_accepted.auction_id
    assert_equal '270265', @offer_automatically_accepted.auction_id
    assert_equal '277687', @offer_declined.auction_id
    assert_equal '270265', @purchase_price_paid.auction_id
  end

  test '#auction_title' do
    title = '24.03.-25.03. Aggregaatti Lutian 6 kVA 230/400 diesel, sähköstartti, Silent -malli, UUSI, Lahti'
    assert_equal title, @auction_ended.auction_title

    title = 'Coca-Cola jääkaappi, 62 litraa, UUSI, takuu 24 kk'
    assert_equal title, @bidder_picks_up.auction_title

    title = 'Auton keinunostin, 1500 kg, UUSI'
    assert_equal title, @delivery_offer_request.auction_title

    title = '2,5 KW petroolilämmitin, UUSI, takuu 12 kk'
    assert_equal title, @delivery_ordered.auction_title

    title = '18.03.-25.03. SkyJack SJ III - 3219 saksilavanostin, Lahti'
    assert_equal title, @offer_accepted.auction_title

    title = '20.03.-25.03. Auton keinunostin, 1500 kg, UUSI, Lahti'
    assert_equal title, @offer_automatically_accepted.auction_title

    title = '20.03.-25.03. Vaijerikeloja lavalla, Lahti'
    assert_equal title, @offer_declined.auction_title

    title = '20.03.-25.03. Auton keinunostin, 1500 kg, UUSI, Lahti'
    assert_equal title, @purchase_price_paid.auction_title
  end

  test '#auction_closing_date' do
    assert_equal "2016-03-25 20:30".to_time, @auction_ended.auction_closing_date
    assert_equal "2016-04-13 19:45".to_time, @bidder_picks_up.auction_closing_date
    assert_equal "2016-03-25 20:20".to_time, @delivery_offer_request.auction_closing_date
    assert_equal "2016-03-25 19:38".to_time, @delivery_ordered.auction_closing_date
    assert_equal "2016-03-25 20:10".to_time, @offer_accepted.auction_closing_date
    assert_equal "2016-03-25 20:20".to_time, @offer_automatically_accepted.auction_closing_date
    assert_equal "2016-03-25 19:40".to_time, @offer_declined.auction_closing_date
    assert_equal "2016-03-25 20:20".to_time, @purchase_price_paid.auction_closing_date
  end

  test '#auction_price_without_vat' do
    assert_equal 650, @auction_ended.auction_price_without_vat
    assert_equal 170, @bidder_picks_up.auction_price_without_vat
    assert_equal 300, @delivery_offer_request.auction_price_without_vat
    assert_equal 90,  @delivery_ordered.auction_price_without_vat
    assert_equal 665, @offer_accepted.auction_price_without_vat
    assert_equal 300, @offer_automatically_accepted.auction_price_without_vat
    assert_equal 50,  @offer_declined.auction_price_without_vat
    assert_equal 300, @purchase_price_paid.auction_price_without_vat
  end

  test '#auction_price_with_vat' do
    assert_equal 806.0, @auction_ended.auction_price_with_vat
    assert_equal 210.8, @bidder_picks_up.auction_price_with_vat
    assert_equal 372.0, @delivery_offer_request.auction_price_with_vat
    assert_equal 111.6, @delivery_ordered.auction_price_with_vat
    assert_equal 824.6, @offer_accepted.auction_price_with_vat
    assert_equal 372.0, @offer_automatically_accepted.auction_price_with_vat
    assert_equal 62.0,  @offer_declined.auction_price_with_vat
    assert_equal 372.0, @purchase_price_paid.auction_price_with_vat
  end

  test '#auction_vat_percent' do
    assert_equal 24, @auction_ended.auction_vat_percent
    assert_equal 24, @bidder_picks_up.auction_vat_percent
    assert_equal 24, @delivery_offer_request.auction_vat_percent
    assert_equal 24, @delivery_ordered.auction_vat_percent
    assert_equal 24, @offer_accepted.auction_vat_percent
    assert_equal 24, @offer_automatically_accepted.auction_vat_percent
    assert_equal 24, @offer_declined.auction_vat_percent
    assert_equal 24, @purchase_price_paid.auction_vat_percent
  end

  test '#auction_vat_amount' do
    assert_equal 156.0, @auction_ended.auction_vat_amount
    assert_equal 40.8,  @bidder_picks_up.auction_vat_amount
    assert_equal 72.0,  @delivery_offer_request.auction_vat_amount
    assert_equal 21.6,  @delivery_ordered.auction_vat_amount
    assert_equal 159.6, @offer_accepted.auction_vat_amount
    assert_equal 72.0,  @offer_automatically_accepted.auction_vat_amount
    assert_equal 12.0,  @offer_declined.auction_vat_amount
    assert_equal 72.0,  @purchase_price_paid.auction_vat_amount
  end

  test '#create_or_find_customer' do
    [@offer_accepted, @offer_automatically_accepted, @purchase_price_paid].each do |mail|
      assert_difference 'Customer.count' do
        mail.create_or_find_customer
      end

      customer = Customer.last

      assert_equal mail.customer_name,     customer.nimi
      assert_equal mail.customer_email,    customer.email
      assert_equal mail.customer_phone,    customer.gsm
      assert_equal mail.customer_address,  customer.osoite
      assert_equal mail.customer_postcode, customer.postino
      assert_equal mail.customer_city,     customer.postitp

      Customer.last.destroy!
    end

    assert_no_difference 'Customer.count' do
      @emails_without_customer_info.each(&:create_or_find_customer)
    end
  end

  test '#find_customer' do
    assert_equal customers(:huutokauppa_customer_1), @offer_accepted.find_customer
    assert_equal customers(:huutokauppa_customer_2), @offer_automatically_accepted.find_customer
    assert_equal customers(:huutokauppa_customer_2), @purchase_price_paid.find_customer

    @emails_without_customer_info.each do |email|
      assert_nil email.find_customer
    end
  end

  test '#find_order' do
    assert_equal sales_order_drafts(:huutokauppa_279590), @auction_ended.find_order
    assert_equal sales_order_drafts(:huutokauppa_285888), @bidder_picks_up.find_order
    assert_equal sales_order_drafts(:huutokauppa_270265), @delivery_offer_request.find_order
    assert_equal sales_order_drafts(:huutokauppa_274472), @delivery_ordered.find_order
    assert_equal sales_order_drafts(:huutokauppa_277075), @offer_accepted.find_order
    assert_equal sales_order_drafts(:huutokauppa_270265), @offer_automatically_accepted.find_order
    assert_equal sales_order_drafts(:huutokauppa_277687), @offer_declined.find_order
    assert_equal sales_order_drafts(:huutokauppa_270265), @purchase_price_paid.find_order
  end
end
