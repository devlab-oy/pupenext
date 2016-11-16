require 'minitest/mock'
require 'test_helper'

class HuutokauppaMailTest < ActiveSupport::TestCase
  fixtures %w(
    countries
    currencies
    customers
    delivery_methods
    head_details
    keyword/customer_categories
    keyword/customer_categories
    keyword/customer_subcategories
    keywords
    products
    sales_order/drafts
    sales_order/orders
    sales_order/rows
    terms_of_payments
  )

  setup do
    Current.user = users(:bob)

    # setup all emails
    @auction_ended                  = HuutokauppaMail.new huutokauppa_email(:auction_ended_1)
    @bidder_picks_up                = HuutokauppaMail.new huutokauppa_email(:bidder_picks_up_1)
    @delivery_offer_request         = HuutokauppaMail.new huutokauppa_email(:delivery_offer_request_1)
    @delivery_ordered               = HuutokauppaMail.new huutokauppa_email(:delivery_ordered_1)
    @invalid_customer_info          = HuutokauppaMail.new huutokauppa_email(:invalid_customer_info)
    @offer_accepted                 = HuutokauppaMail.new huutokauppa_email(:offer_accepted_1)
    @offer_accepted_2               = HuutokauppaMail.new huutokauppa_email(:offer_accepted_2)
    @offer_accepted_3               = HuutokauppaMail.new huutokauppa_email(:offer_accepted_3)
    @offer_automatically_accepted   = HuutokauppaMail.new huutokauppa_email(:offer_automatically_accepted_1)
    @offer_automatically_accepted_2 = HuutokauppaMail.new huutokauppa_email(:offer_automatically_accepted_2)
    @offer_declined                 = HuutokauppaMail.new huutokauppa_email(:offer_declined_1)
    @purchase_price_paid            = HuutokauppaMail.new huutokauppa_email(:purchase_price_paid_1)
    @purchase_price_paid_2          = HuutokauppaMail.new huutokauppa_email(:purchase_price_paid_2)
    @purchase_price_paid_3          = HuutokauppaMail.new huutokauppa_email(:purchase_price_paid_3)

    @emails_without_customer_info = [
      @auction_ended,
      @bidder_picks_up,
      @delivery_offer_request,
      @delivery_ordered,
      @offer_declined,
    ]

    @emails_without_delivery_info = [
      @auction_ended,
      @bidder_picks_up,
      @offer_accepted,
      @offer_accepted_2,
      @offer_accepted_3,
      @offer_automatically_accepted,
      @offer_automatically_accepted_2,
      @offer_declined,
      @purchase_price_paid,
      @purchase_price_paid_2,
      @purchase_price_paid_3,
    ]
  end

  test 'exception is thrown if company and user are not set' do
    file = huutokauppa_email(:offer_automatically_accepted_1)

    Current.company = nil
    assert_raise { HuutokauppaMail.new(file) }

    Current.company = companies(:acme)
    Current.user    = nil
    assert_raise { HuutokauppaMail.new(file) }
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
    assert_equal :offer_accepted,               @offer_accepted_2.type
    assert_equal :offer_accepted,               @offer_accepted_3.type
    assert_equal :offer_automatically_accepted, @offer_automatically_accepted.type
    assert_equal :offer_automatically_accepted, @offer_automatically_accepted_2.type
    assert_equal :offer_declined,               @offer_declined.type
    assert_equal :purchase_price_paid,          @purchase_price_paid.type
    assert_equal :purchase_price_paid,          @purchase_price_paid_2.type
    assert_equal :purchase_price_paid,          @purchase_price_paid_3.type
  end

  test '#company_name' do
    assert_equal 'Testites Oy',     @offer_accepted_2.company_name
    assert_equal 'Testit ky T',     @offer_accepted_3.company_name
    assert_equal 'TE-Testitest Oy', @offer_automatically_accepted_2.company_name

    assert_nil @auction_ended.company_name
    assert_nil @bidder_picks_up.company_name
    assert_nil @delivery_offer_request.company_name
    assert_nil @delivery_ordered.company_name
    assert_nil @invalid_customer_info.company_name
    assert_nil @offer_accepted.company_name
    assert_nil @offer_automatically_accepted.company_name
    assert_nil @offer_declined.company_name
    assert_nil @purchase_price_paid.company_name
    assert_nil @purchase_price_paid_2.company_name
    assert_nil @purchase_price_paid_3.company_name
  end

  test '#company_id' do
    assert_equal 'FI01234567', @offer_accepted_2.company_id
    assert_equal 'FI23456789', @offer_accepted_3.company_id
    assert_equal '1234567-8',  @offer_automatically_accepted_2.company_id

    assert_nil @auction_ended.company_id
    assert_nil @bidder_picks_up.company_id
    assert_nil @delivery_offer_request.company_id
    assert_nil @delivery_ordered.company_id
    assert_nil @invalid_customer_info.company_id
    assert_nil @offer_accepted.company_id
    assert_nil @offer_automatically_accepted.company_id
    assert_nil @offer_declined.company_id
    assert_nil @purchase_price_paid.company_id
    assert_nil @purchase_price_paid_2.company_id
    assert_nil @purchase_price_paid_3.company_id
  end

  test '#customer_name' do
    assert_equal 'Testi Testit Testitestit',   @offer_accepted.customer_name
    assert_equal 'Testi Testiä',               @offer_accepted_2.customer_name
    assert_equal 'Testit ky T',                @offer_accepted_3.customer_name
    assert_equal 'Test-testi Testite',         @offer_automatically_accepted.customer_name
    assert_equal 'Test testi testit Testites', @offer_automatically_accepted_2.customer_name
    assert_equal 'Test-testi Testite',         @purchase_price_paid.customer_name
    assert_equal 'Test testit Testi',          @purchase_price_paid_2.customer_name
    assert_equal 'Test test testi Testite',    @purchase_price_paid_3.customer_name

    @emails_without_customer_info.each do |mail|
      assert_nil mail.customer_name
    end
  end

  test '#customer_name returns nil if name is not found' do
    assert_nil @invalid_customer_info.customer_name
  end

  test '#customer_email' do
    assert_equal 'testit@testi.tes',          @offer_accepted.customer_email
    assert_equal 'testi.testit@testit.te',    @offer_accepted_2.customer_email
    assert_equal 'testitest@testi.tes',       @offer_accepted_3.customer_email
    assert_equal 'te.testite@testi.tes',      @offer_automatically_accepted.customer_email
    assert_equal 'test@te-testitest.te',      @offer_automatically_accepted_2.customer_email
    assert_equal 'te.testite@testi.tes',      @purchase_price_paid.customer_email
    assert_equal 'test.testi@testitestit.fi', @purchase_price_paid_2.customer_email
    assert_equal 'testite@testite.tes',       @purchase_price_paid_3.customer_email

    @emails_without_customer_info.each do |mail|
      assert_nil mail.customer_email
    end
  end

  test '#customer_phone' do
    assert_equal '+123 45 6789012', @offer_accepted.customer_phone
    assert_equal '+123 45 6789012', @offer_accepted_2.customer_phone
    assert_equal '+012 34 5678901', @offer_accepted_3.customer_phone
    assert_equal '+123 45 6789012', @offer_automatically_accepted.customer_phone
    assert_equal '+123 45 6789012', @offer_automatically_accepted_2.customer_phone
    assert_equal '+123 45 6789012', @purchase_price_paid.customer_phone
    assert_equal '+123 45 6789012', @purchase_price_paid_2.customer_phone
    assert_equal '+123 45 6789012', @purchase_price_paid_3.customer_phone

    @emails_without_customer_info.each do |mail|
      assert_nil mail.customer_phone
    end
  end

  test '#customer_address' do
    assert_equal 'testitestit 12',     @offer_accepted.customer_address
    assert_equal 'Testites 52',        @offer_accepted_2.customer_address
    assert_equal 'testitestäites 222', @offer_accepted_3.customer_address
    assert_equal 'Testitesti 123',     @offer_automatically_accepted.customer_address
    assert_equal 'Testitestit 1 k',    @offer_automatically_accepted_2.customer_address
    assert_equal 'Testitesti 123',     @purchase_price_paid.customer_address
    assert_equal 'Testitest 21',       @purchase_price_paid_2.customer_address
    assert_equal 'Testiteäki 12 A 1',  @purchase_price_paid_3.customer_address

    @emails_without_customer_info.each do |mail|
      assert_nil mail.customer_address
    end
  end

  test '#customer_postcode' do
    assert_equal '12345', @offer_accepted.customer_postcode
    assert_equal '12345', @offer_accepted_2.customer_postcode
    assert_equal '98765', @offer_accepted_3.customer_postcode
    assert_equal '23456', @offer_automatically_accepted.customer_postcode
    assert_equal '12345', @offer_automatically_accepted_2.customer_postcode
    assert_equal '12345', @purchase_price_paid.customer_postcode
    assert_equal '12345', @purchase_price_paid_2.customer_postcode
    assert_equal '12345', @purchase_price_paid_3.customer_postcode

    @emails_without_customer_info.each do |mail|
      assert_nil mail.customer_postcode
    end
  end

  test '#customer_city' do
    assert_equal 'Testi',      @offer_accepted.customer_city
    assert_equal 'Testätes',   @offer_accepted_2.customer_city
    assert_equal 'Testi',      @offer_accepted_3.customer_city
    assert_equal 'Testitesti', @offer_automatically_accepted.customer_city
    assert_equal 'Testite',    @offer_automatically_accepted_2.customer_city
    assert_equal 'Testitesti', @purchase_price_paid.customer_city
    assert_equal 'Testi',      @purchase_price_paid_2.customer_city
    assert_equal 'testite',    @purchase_price_paid_3.customer_city

    @emails_without_customer_info.each do |mail|
      assert_nil mail.customer_city
    end
  end

  test '#customer_country' do
    assert_equal 'Suomi', @offer_accepted.customer_country
    assert_equal 'Suomi', @offer_accepted_2.customer_country
    assert_equal 'Suomi', @offer_accepted_3.customer_country
    assert_equal 'Suomi', @offer_automatically_accepted.customer_country
    assert_equal 'Suomi', @offer_automatically_accepted_2.customer_country
    assert_equal 'Suomi', @purchase_price_paid.customer_country
    assert_equal 'Suomi', @purchase_price_paid_2.customer_country
    assert_equal 'Suomi', @purchase_price_paid_3.customer_country

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

  test '#delivery_price_without_vat' do
    assert_equal 0.0,   @bidder_picks_up.delivery_price_without_vat
    assert_equal 14.47, @delivery_ordered.delivery_price_without_vat
    assert_equal 0.0,   @purchase_price_paid_2.delivery_price_without_vat
    assert_equal 14.47, @purchase_price_paid_3.delivery_price_without_vat

    assert_nil @auction_ended.delivery_price_without_vat
    assert_nil @delivery_offer_request.delivery_price_without_vat
    assert_nil @offer_accepted.delivery_price_without_vat
    assert_nil @offer_accepted_2.delivery_price_without_vat
    assert_nil @offer_accepted_3.delivery_price_without_vat
    assert_nil @offer_automatically_accepted.delivery_price_without_vat
    assert_nil @offer_automatically_accepted_2.delivery_price_without_vat
    assert_nil @offer_declined.delivery_price_without_vat
    assert_nil @purchase_price_paid.delivery_price_without_vat
  end

  test '#delivery_price_with_vat' do
    assert_equal 0.0,   @bidder_picks_up.delivery_price_with_vat
    assert_equal 17.95, @delivery_ordered.delivery_price_with_vat
    assert_equal 0.0,   @purchase_price_paid_2.delivery_price_with_vat
    assert_equal 17.95, @purchase_price_paid_3.delivery_price_with_vat

    assert_nil @auction_ended.delivery_price_with_vat
    assert_nil @delivery_offer_request.delivery_price_with_vat
    assert_nil @offer_accepted.delivery_price_with_vat
    assert_nil @offer_accepted_2.delivery_price_with_vat
    assert_nil @offer_accepted_3.delivery_price_with_vat
    assert_nil @offer_automatically_accepted.delivery_price_with_vat
    assert_nil @offer_automatically_accepted_2.delivery_price_with_vat
    assert_nil @offer_declined.delivery_price_with_vat
    assert_nil @purchase_price_paid.delivery_price_with_vat
  end

  test '#delivery_vat_percent' do
    assert_equal 24.0, @bidder_picks_up.delivery_vat_percent
    assert_equal 24.0, @delivery_ordered.delivery_vat_percent
    assert_equal 24.0, @purchase_price_paid_2.delivery_vat_percent
    assert_equal 24.0, @purchase_price_paid_3.delivery_vat_percent

    assert_nil @auction_ended.delivery_vat_percent
    assert_nil @delivery_offer_request.delivery_vat_percent
    assert_nil @offer_accepted.delivery_vat_percent
    assert_nil @offer_accepted_2.delivery_vat_percent
    assert_nil @offer_accepted_3.delivery_vat_percent
    assert_nil @offer_automatically_accepted.delivery_vat_percent
    assert_nil @offer_automatically_accepted_2.delivery_vat_percent
    assert_nil @offer_declined.delivery_vat_percent
    assert_nil @purchase_price_paid.delivery_vat_percent
  end

  test '#delivery_vat_amount' do
    assert_equal 0.0,  @bidder_picks_up.delivery_vat_amount
    assert_equal 3.48, @delivery_ordered.delivery_vat_amount
    assert_equal 0.0,  @purchase_price_paid_2.delivery_vat_amount
    assert_equal 3.48, @purchase_price_paid_3.delivery_vat_amount

    assert_nil @auction_ended.delivery_vat_amount
    assert_nil @delivery_offer_request.delivery_vat_amount
    assert_nil @offer_accepted.delivery_vat_amount
    assert_nil @offer_accepted_2.delivery_vat_amount
    assert_nil @offer_accepted_3.delivery_vat_amount
    assert_nil @offer_automatically_accepted.delivery_vat_amount
    assert_nil @offer_automatically_accepted_2.delivery_vat_amount
    assert_nil @offer_declined.delivery_vat_amount
    assert_nil @purchase_price_paid.delivery_vat_amount
  end

  test '#total_price_with_vat' do
    assert_equal 210.8,      @bidder_picks_up.total_price_with_vat
    assert_equal 129.55,     @delivery_ordered.total_price_with_vat
    assert_equal 806.0,      @auction_ended.total_price_with_vat
    assert_equal 372.0,      @delivery_offer_request.total_price_with_vat
    assert_equal 824.6,      @offer_accepted.total_price_with_vat
    assert_equal 10_664.0,   @offer_accepted_2.total_price_with_vat
    assert_equal 2000.0,     @offer_accepted_3.total_price_with_vat
    assert_equal 372.0,      @offer_automatically_accepted.total_price_with_vat
    assert_equal 279.0,      @offer_automatically_accepted_2.total_price_with_vat
    assert_equal 62.0,       @offer_declined.total_price_with_vat
    assert_equal 372.0,      @purchase_price_paid.total_price_with_vat
    assert_equal 248.0,      @purchase_price_paid_2.total_price_with_vat
    assert_equal 92.35.to_d, @purchase_price_paid_3.total_price_with_vat
  end

  test '#auction_id' do
    assert_equal '279590', @auction_ended.auction_id
    assert_equal '285888', @bidder_picks_up.auction_id
    assert_equal '270265', @delivery_offer_request.auction_id
    assert_equal '274472', @delivery_ordered.auction_id
    assert_equal '277075', @offer_accepted.auction_id
    assert_equal '293363', @offer_accepted_2.auction_id
    assert_equal '298958', @offer_accepted_3.auction_id
    assert_equal '270265', @offer_automatically_accepted.auction_id
    assert_equal '294627', @offer_automatically_accepted_2.auction_id
    assert_equal '277687', @offer_declined.auction_id
    assert_equal '270265', @purchase_price_paid.auction_id
    assert_equal '287912', @purchase_price_paid_2.auction_id
    assert_equal '285703', @purchase_price_paid_3.auction_id
  end

  test '#auction_title' do
    title = 'Aggregaatti Lutian 6 kVA 230/400 diesel, sähköstartti, Silent -malli, UUSI, Lahti'
    assert_equal title, @auction_ended.auction_title

    title = 'Coca-Cola jääkaappi, 62 litraa, UUSI, takuu 24 kk'
    assert_equal title, @bidder_picks_up.auction_title

    title = 'Auton keinunostin, 1500 kg, UUSI'
    assert_equal title, @delivery_offer_request.auction_title

    title = '2,5 KW petroolilämmitin, UUSI, takuu 12 kk'
    assert_equal title, @delivery_ordered.auction_title

    title = 'SkyJack SJ III - 3219 saksilavanostin, Lahti'
    assert_equal title, @offer_accepted.auction_title

    title = 'BOBCAT 320 kaivinkone, Lahti'
    assert_equal title, @offer_accepted_2.auction_title

    title = 'Kompressorivaunu Ingersoll Rand 7/31, Lahti'
    assert_equal title, @offer_accepted_3.auction_title

    title = 'Auton keinunostin, 1500 kg, UUSI, Lahti'
    assert_equal title, @offer_automatically_accepted.auction_title

    title = 'Tasapainoskootteri, väri punainen, UUSI, Lahti'
    assert_equal title, @offer_automatically_accepted_2.auction_title

    title = 'Vaijerikeloja lavalla, Lahti'
    assert_equal title, @offer_declined.auction_title

    title = 'Auton keinunostin, 1500 kg, UUSI, Lahti'
    assert_equal title, @purchase_price_paid.auction_title

    title = 'Tunkkisetti. 20-30 tonnia, UUSIA, Lahti'
    assert_equal title, @purchase_price_paid_2.auction_title

    title = 'KAPPA reppu + KAPPA treenikassi + KAPPA sukat, UUSIA, Lahti'
    assert_equal title, @purchase_price_paid_3.auction_title
  end

  test '#auction_closing_date' do
    assert_equal Time.zone.parse("2016-03-25 20:30"), @auction_ended.auction_closing_date
    assert_equal Time.zone.parse("2016-04-13 19:45"), @bidder_picks_up.auction_closing_date
    assert_equal Time.zone.parse("2016-03-25 20:20"), @delivery_offer_request.auction_closing_date
    assert_equal Time.zone.parse("2016-03-25 19:38"), @delivery_ordered.auction_closing_date
    assert_equal Time.zone.parse("2016-03-25 20:10"), @offer_accepted.auction_closing_date
    assert_equal Time.zone.parse("2016-05-01 20:25"), @offer_accepted_2.auction_closing_date
    assert_equal Time.zone.parse("2016-05-15 19:52"), @offer_accepted_3.auction_closing_date
    assert_equal Time.zone.parse("2016-03-25 20:20"), @offer_automatically_accepted.auction_closing_date
    assert_equal Time.zone.parse("2016-05-15 21:00"), @offer_automatically_accepted_2.auction_closing_date
    assert_equal Time.zone.parse("2016-03-25 19:40"), @offer_declined.auction_closing_date
    assert_equal Time.zone.parse("2016-03-25 20:20"), @purchase_price_paid.auction_closing_date
    assert_equal Time.zone.parse("2016-04-23 19:40"), @purchase_price_paid_2.auction_closing_date
    assert_equal Time.zone.parse("2016-04-26 19:46"), @purchase_price_paid_3.auction_closing_date
  end

  test '#auction_price_without_vat' do
    assert_equal 650,  @auction_ended.auction_price_without_vat
    assert_equal 170,  @bidder_picks_up.auction_price_without_vat
    assert_equal 300,  @delivery_offer_request.auction_price_without_vat
    assert_equal 90,   @delivery_ordered.auction_price_without_vat
    assert_equal 665,  @offer_accepted.auction_price_without_vat
    assert_equal 8600, @offer_accepted_2.auction_price_without_vat
    assert_equal 2000, @offer_accepted_3.auction_price_without_vat
    assert_equal 300,  @offer_automatically_accepted.auction_price_without_vat
    assert_equal 225,  @offer_automatically_accepted_2.auction_price_without_vat
    assert_equal 50,   @offer_declined.auction_price_without_vat
    assert_equal 300,  @purchase_price_paid.auction_price_without_vat
    assert_equal 200,  @purchase_price_paid_2.auction_price_without_vat
    assert_equal 60,   @purchase_price_paid_3.auction_price_without_vat
  end

  test '#auction_price_with_vat' do
    assert_equal 806.0,     @auction_ended.auction_price_with_vat
    assert_equal 210.8,     @bidder_picks_up.auction_price_with_vat
    assert_equal 372.0,     @delivery_offer_request.auction_price_with_vat
    assert_equal 111.6,     @delivery_ordered.auction_price_with_vat
    assert_equal 824.6,     @offer_accepted.auction_price_with_vat
    assert_equal 10_664.0,  @offer_accepted_2.auction_price_with_vat
    assert_equal 2000.0,    @offer_accepted_3.auction_price_with_vat
    assert_equal 372.0,     @offer_automatically_accepted.auction_price_with_vat
    assert_equal 279.0,     @offer_automatically_accepted_2.auction_price_with_vat
    assert_equal 62.0,      @offer_declined.auction_price_with_vat
    assert_equal 372.0,     @purchase_price_paid.auction_price_with_vat
    assert_equal 248.0,     @purchase_price_paid_2.auction_price_with_vat
    assert_equal 74.4.to_d, @purchase_price_paid_3.auction_price_with_vat
  end

  test '#auction_vat_percent' do
    assert_equal 24, @auction_ended.auction_vat_percent
    assert_equal 24, @bidder_picks_up.auction_vat_percent
    assert_equal 24, @delivery_offer_request.auction_vat_percent
    assert_equal 24, @delivery_ordered.auction_vat_percent
    assert_equal 24, @offer_accepted.auction_vat_percent
    assert_equal 24, @offer_accepted_2.auction_vat_percent
    assert_equal 0,  @offer_accepted_3.auction_vat_percent
    assert_equal 24, @offer_automatically_accepted.auction_vat_percent
    assert_equal 24, @offer_automatically_accepted_2.auction_vat_percent
    assert_equal 24, @offer_declined.auction_vat_percent
    assert_equal 24, @purchase_price_paid.auction_vat_percent
    assert_equal 24, @purchase_price_paid_2.auction_vat_percent
    assert_equal 24, @purchase_price_paid_3.auction_vat_percent
  end

  test '#auction_vat_amount' do
    assert_equal 156.0,  @auction_ended.auction_vat_amount
    assert_equal 40.8,   @bidder_picks_up.auction_vat_amount
    assert_equal 72.0,   @delivery_offer_request.auction_vat_amount
    assert_equal 21.6,   @delivery_ordered.auction_vat_amount
    assert_equal 159.6,  @offer_accepted.auction_vat_amount
    assert_equal 2064.0, @offer_accepted_2.auction_vat_amount
    assert_equal 0,      @offer_accepted_3.auction_vat_amount
    assert_equal 72.0,   @offer_automatically_accepted.auction_vat_amount
    assert_equal 54.0,   @offer_automatically_accepted_2.auction_vat_amount
    assert_equal 12.0,   @offer_declined.auction_vat_amount
    assert_equal 72.0,   @purchase_price_paid.auction_vat_amount
    assert_equal 48.0,   @purchase_price_paid_2.auction_vat_amount
    assert_equal 14.4,   @purchase_price_paid_3.auction_vat_amount
  end

  test '#find_customer' do
    assert_equal customers(:huutokauppa_customer_1), @offer_accepted.find_customer
    assert_equal customers(:huutokauppa_customer_2), @offer_automatically_accepted.find_customer
    assert_equal customers(:huutokauppa_customer_2), @purchase_price_paid.find_customer

    assert_nil @offer_accepted_2.find_customer
    assert_nil @offer_accepted_3.find_customer
    assert_nil @offer_automatically_accepted_2.find_customer
    assert_nil @purchase_price_paid_2.find_customer
    assert_nil @purchase_price_paid_3.find_customer

    @emails_without_customer_info.each do |email|
      assert_nil email.find_customer
    end
  end

  test '#create_customer' do
    [
      @offer_accepted,
      @offer_accepted_2,
      @offer_accepted_3,
      @offer_automatically_accepted,
      @offer_automatically_accepted_2,
      @purchase_price_paid,
      @purchase_price_paid_2,
      @purchase_price_paid_3,
    ].each do |email|
      Customer.delete_all

      assert_difference 'Customer.count' do
        email.create_customer

        if email.company_name
          assert_empty Customer.last.laji
        else
          assert_equal 'H', Customer.last.laji
        end

        customer_category = keyword_customer_categories(:customer_category_1)

        assert_equal email.name,                       Customer.last.nimi
        assert_equal delivery_methods(:nouto),         Customer.last.delivery_method
        assert_equal terms_of_payments(:two_days_net), Customer.last.terms_of_payment
        assert_equal '667',                            Customer.last.chn
        assert_equal '1',                              Customer.last.piiri
        assert_equal customer_category,                Customer.last.category
        assert_equal 24,                               Customer.last.alv

        assert_includes email.messages, "Asiakas #{Customer.last.nimi} (#{Customer.last.email}) luotu."
      end
    end

    @emails_without_customer_info.each do |email|
      assert_no_difference 'Customer.count' do
        email.create_customer

        assert_empty email.messages
      end
    end
  end

  test '#create_customer logs errors' do
    Customer.delete_all
    Customer.new(ytunnus: @offer_accepted_2.company_id).save(validate: false)

    customer = @offer_accepted_2.create_customer

    message = "Asiakkaan #{customer.nimi} (#{customer.email}) luonti epäonnistui."
    assert_includes @offer_accepted_2.messages.to_s, message
  end

  test '#update_customer' do
    [@offer_accepted, @offer_automatically_accepted, @purchase_price_paid].each do |email|
      assert email.update_customer

      customer_category = keyword_customer_categories(:customer_category_1)

      assert_equal '1',               email.find_customer.piiri
      assert_equal customer_category, email.find_customer.category

      assert_includes email.messages, "Asiakas #{email.find_customer.nimi} (#{email.find_customer.email}) päivitetty."
    end

    @emails_without_customer_info.each do |email|
      refute email.update_customer

      assert_empty email.messages
    end
  end

  test '#update_customer logs errors' do
    @offer_accepted.find_customer.update_column(:ytunnus, '')

    refute @offer_accepted.update_customer

    message = "Asiakkaan #{@offer_accepted.find_customer.nimi} (#{@offer_accepted.find_customer.email}) " \
              "tietojen päivitys epäonnistui."
    assert_includes @offer_accepted.messages.to_s, message
  end

  test '#find_draft' do
    assert_equal sales_order_drafts(:huutokauppa_279590), @auction_ended.find_draft
    assert_equal sales_order_drafts(:huutokauppa_285888), @bidder_picks_up.find_draft
    assert_equal sales_order_drafts(:huutokauppa_270265), @delivery_offer_request.find_draft
    assert_equal sales_order_drafts(:huutokauppa_274472), @delivery_ordered.find_draft
    assert_equal sales_order_drafts(:huutokauppa_277075), @offer_accepted.find_draft
    assert_equal sales_order_drafts(:huutokauppa_293363), @offer_accepted_2.find_draft
    assert_equal sales_order_drafts(:huutokauppa_298958), @offer_accepted_3.find_draft
    assert_equal sales_order_drafts(:huutokauppa_270265), @offer_automatically_accepted.find_draft
    assert_equal sales_order_drafts(:huutokauppa_294627), @offer_automatically_accepted_2.find_draft
    assert_equal sales_order_drafts(:huutokauppa_277687), @offer_declined.find_draft
    assert_equal sales_order_drafts(:huutokauppa_270265), @purchase_price_paid.find_draft
    assert_equal sales_order_drafts(:huutokauppa_287912), @purchase_price_paid_2.find_draft
    assert_equal sales_order_drafts(:huutokauppa_285703), @purchase_price_paid_3.find_draft
  end

  test '#find_draft raises exception and logs errors' do
    sales_order_drafts(:huutokauppa_279590).delete

    exception = assert_raise(ActiveRecord::RecordNotFound) do
      @auction_ended.find_draft
    end

    assert_equal 'Kesken olevaa myyntitilausta ei löytynyt huutokaupalle 279590.', exception.message
  end

  test '#update_order_customer_info' do
    [
      @offer_accepted,
      @offer_accepted_2,
      @offer_accepted_3,
      @offer_automatically_accepted,
      @offer_automatically_accepted_2,
      @purchase_price_paid,
      @purchase_price_paid_2,
      @purchase_price_paid_3,
    ].each do |email|
      assert email.update_order_customer_info

      if email.company_name
        assert_equal email.company_name, email.find_draft.nimi
        assert_equal email.company_name, email.find_draft.toim_nimi
        assert_equal email.company_name, email.find_draft.laskutus_nimi
      else
        assert_equal email.customer_name, email.find_draft.nimi
        assert_equal email.customer_name, email.find_draft.toim_nimi
        assert_equal email.customer_name, email.find_draft.laskutus_nimi
      end

      assert_empty                          email.find_draft.nimitark
      assert_equal email.customer_address,  email.find_draft.osoite
      assert_empty                          email.find_draft.osoitetark
      assert_equal email.customer_postcode, email.find_draft.postino
      assert_equal email.customer_city,     email.find_draft.postitp
      assert_equal email.customer_phone,    email.find_draft.puh
      assert_equal email.customer_email,    email.find_draft.email

      assert_empty                          email.find_draft.toim_nimitark
      assert_equal email.customer_address,  email.find_draft.toim_osoite
      assert_equal email.customer_postcode, email.find_draft.toim_postino
      assert_equal email.customer_city,     email.find_draft.toim_postitp
      assert_equal email.customer_phone,    email.find_draft.toim_puh
      assert_equal email.customer_email,    email.find_draft.toim_email

      assert_empty                          email.find_draft.laskutus_nimitark
      assert_equal email.customer_address,  email.find_draft.laskutus_osoite
      assert_equal email.customer_postcode, email.find_draft.laskutus_postino
      assert_equal email.customer_city,     email.find_draft.laskutus_postitp

      message = "Päivitettiin tilauksen (Tilausnumero: #{email.find_draft.id}, Huutokauppa: #{email.auction_id}) asiakastiedot."
      assert_includes email.messages, message
    end

    @emails_without_customer_info.each do |email|
      refute email.update_order_customer_info

      assert_empty email.messages
    end
  end

  test '#update_order_delivery_info' do
    [@delivery_offer_request, @delivery_ordered].each do |email|
      assert email.update_order_delivery_info

      assert_equal email.delivery_address,  email.find_draft.toim_osoite
      assert_equal email.delivery_city,     email.find_draft.toim_postitp
      assert_equal email.delivery_email,    email.find_draft.toim_email
      assert_equal email.delivery_name,     email.find_draft.toim_nimi
      assert_equal email.delivery_phone,    email.find_draft.toim_puh
      assert_equal email.delivery_postcode, email.find_draft.toim_postino

      message = "Päivitettiin tilauksen (Tilausnumero: #{email.find_draft.id}, Huutokauppa: #{email.auction_id}) toimitustiedot."
      assert_includes email.messages, message
    end

    @emails_without_delivery_info.each do |email|
      refute email.update_order_delivery_info

      assert_empty email.messages
    end
  end

  test '#update_order_product_info' do
    [
      @auction_ended,
      @bidder_picks_up,
      @delivery_offer_request,
      @delivery_ordered,
      @offer_accepted,
      @offer_accepted_2,
      @offer_accepted_3,
      @offer_automatically_accepted,
      @offer_automatically_accepted_2,
      @offer_declined,
      @purchase_price_paid,
      @purchase_price_paid_2,
      @purchase_price_paid_3,
    ].each do |email|
      assert email.update_order_product_info

      row = email.find_draft.rows.first
      qty = row.tilkpl

      assert_equal (email.auction_price_without_vat / qty).round(2), row.hinta.round(2)
      assert_equal (email.auction_price_without_vat / qty).round(2), row.hinta_alkuperainen.round(2)
      assert_equal (email.auction_price_without_vat / qty).round(2), row.hinta_valuutassa.round(2)
      assert_equal email.auction_price_without_vat,       row.rivihinta
      assert_equal email.auction_price_without_vat,       row.rivihinta_valuutassa
      assert_equal email.auction_title,                   row.nimitys
      assert_equal email.auction_vat_percent,             row.alv

      message = "Päivitettiin tilauksen (Tilausnumero: #{email.find_draft.id}, Huutokauppa: #{email.auction_id}) tuotetiedot"
      assert_includes email.messages.to_s, message
    end
  end

  test '#update_order_product_info with tuoteperhe calls legacy method' do
    row = @offer_accepted.find_draft.rows.first
    row.update!(perheid: row.tunnus)

    LegacyMethods.stub :pupesoft_function, proc { raise ScriptError } do
      assert_raise(ScriptError) { @offer_accepted.update_order_product_info }
    end
  end

  test '#create_sales_order' do
    sales_order_creation = proc do
      sales_order = SalesOrder::Draft.new
      sales_order.save(validate: false)

      { sales_order_id: sales_order.id }
    end

    LegacyMethods.stub :pupesoft_function, sales_order_creation do
      [
        @offer_accepted,
        @offer_accepted_2,
        @offer_accepted_3,
        @offer_automatically_accepted,
        @offer_automatically_accepted_2,
        @purchase_price_paid,
        @purchase_price_paid_2,
        @purchase_price_paid_3,
      ].each do |email|
        assert_difference 'SalesOrder::Draft.count' do
          email.create_sales_order
        end
      end

      @emails_without_customer_info.each do |email|
        assert_no_difference 'SalesOrder::Draft.count' do
          email.create_sales_order
        end
      end
    end
  end

  test '#add_delivery_row' do
    row = nil

    [
      @delivery_ordered,
      @purchase_price_paid_3,
    ].each do |email|
      create_row = proc do
        row = email.find_draft.rows.build
        row.save(validate: false)

        { added_row: row.id }
      end

      LegacyMethods.stub :pupesoft_function, create_row do
        assert_difference 'SalesOrder::Row.count' do
          email.add_delivery_row

          message = "Lisättiin toimitusrivi tilaukselle (Tilausnumero: #{email.find_draft.id}, Huutokauppa: #{email.auction_id})."
          assert_includes email.messages, message
        end
      end
    end

    [
      @auction_ended,
      @bidder_picks_up,
      @delivery_offer_request,
      @offer_accepted,
      @offer_accepted_2,
      @offer_accepted_3,
      @offer_automatically_accepted,
      @offer_automatically_accepted_2,
      @offer_declined,
      @purchase_price_paid,
      @purchase_price_paid_2,
    ].each do |email|
      assert_no_difference 'Row.count' do
        email.add_delivery_row

        assert_empty email.messages
      end
    end
  end

  test '#update_delivery_method_to_nouto' do
    [
      @auction_ended,
      @bidder_picks_up,
      @delivery_offer_request,
      @delivery_ordered,
      @offer_accepted,
      @offer_accepted_2,
      @offer_accepted_3,
      @offer_automatically_accepted,
      @offer_automatically_accepted_2,
      @offer_declined,
      @purchase_price_paid,
      @purchase_price_paid_2,
      @purchase_price_paid_3,
    ].each do |email|
      email.update_delivery_method_to_nouto

      assert_equal delivery_methods(:nouto), email.find_draft.delivery_method
      message = "Päivitettiin tilauksen (Tilausnumero: #{email.find_draft.id}, Huutokauppa: #{email.auction_id}) toimitustavaksi Nouto."
      assert_includes email.messages, message
    end
  end

  test '#update_delivery_method_to_itella_economy_16' do
    [
      @auction_ended,
      @bidder_picks_up,
      @delivery_offer_request,
      @delivery_ordered,
      @offer_accepted,
      @offer_accepted_2,
      @offer_accepted_3,
      @offer_declined,
      @purchase_price_paid_2,
      @purchase_price_paid_3,
    ].each do |email|
      email.update_delivery_method_to_itella_economy_16

      assert_equal delivery_methods(:posti_economy_16), email.find_draft.delivery_method
      message = "Päivitettiin tilauksen (Tilausnumero: #{email.find_draft.id}, Huutokauppa: #{email.auction_id}) toimitustavaksi Posti Economy 16."
      assert_includes email.messages, message
    end
  end

  test '#mark_as_done' do
    [
      @auction_ended,
      @bidder_picks_up,
      @delivery_offer_request,
      @delivery_ordered,
      @offer_accepted,
      @offer_accepted_2,
      @offer_accepted_3,
      @offer_declined,
      @purchase_price_paid_2,
      @purchase_price_paid_3,
    ].each do |email|
      draft = email.find_draft

      mark_as_done = proc do
        draft.tila = 'L'
        draft.save(validate: false)
      end

      LegacyMethods.stub(:pupesoft_function, mark_as_done) do
        assert_difference 'SalesOrder::Draft.count', -1 do
          assert_difference 'SalesOrder::Order.count' do
            email.mark_as_done

            message = "Merkittiin tilaus (Tilausnumero: #{email.find_order.id}, Huutokauppa: #{email.auction_id}) valmiiksi."
            assert_includes email.messages, message
          end
        end
      end
    end
  end

  test '#update_or_create_customer' do
    [
      @offer_accepted,
      @offer_automatically_accepted,
      @purchase_price_paid,
    ].each do |email|
      assert_no_difference 'Customer.count' do
        customer = email.update_or_create_customer

        assert_equal email.find_customer, customer
        assert_equal email.customer_name, customer.nimi

        assert_includes email.messages, "Asiakas #{customer.nimi} (#{customer.email}) löytyi, joten päivitetään kyseisen asiakkaan tiedot."
        assert_includes email.messages, "Asiakas #{customer.nimi} (#{customer.email}) päivitetty."

        assert_equal customer, email.find_draft.customer
      end
    end

    [
      @offer_accepted_2,
      @offer_accepted_3,
      @offer_automatically_accepted_2,
      @purchase_price_paid_2,
      @purchase_price_paid_3,
    ].each do |email|
      assert_difference 'Customer.count' do
        email.update_or_create_customer

        assert_includes email.messages, "Asiakas #{Customer.last.nimi} (#{Customer.last.email}) luotu."

        assert_equal Customer.last, email.find_draft.customer
      end
    end
  end

  test '#name' do
    assert_equal 'Testi Testit Testitestit', @offer_accepted.name
    assert_equal 'Testites Oy',              @offer_accepted_2.name
    assert_equal 'Testit ky T',              @offer_accepted_3.name
    assert_equal 'Test-testi Testite',       @offer_automatically_accepted.name
    assert_equal 'TE-Testitest Oy',          @offer_automatically_accepted_2.name
    assert_equal 'Test-testi Testite',       @purchase_price_paid.name
    assert_equal 'Test testit Testi',        @purchase_price_paid_2.name
    assert_equal 'Test test testi Testite',  @purchase_price_paid_3.name
  end
end
