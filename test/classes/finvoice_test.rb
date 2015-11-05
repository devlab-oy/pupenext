require 'test_helper'

class FinvoiceTest < ActiveSupport::TestCase
  fixtures %w(
    heads
    sales_order/orders
    terms_of_payments
    head/sales_invoice_rows
    head/sales_invoice_extras
    users
  )

  setup do
    Current.company = companies :acme
    @invoice = heads :si_one
  end

  test 'should initialize class with invoice' do
    assert Finvoice.new(invoice_id: @invoice.id)
    assert_raises(ActiveRecord::RecordNotFound) { Finvoice.new(invoice_id: nil) }
  end

  test 'public getter methods' do
    time_now = Time.now
    finvoice = Finvoice.new invoice_id: @invoice.id

    ################################
    ## MessageTransmissionDetails ##
    ################################

    assert_equal "1234567890", finvoice.from_identifier
    assert_equal "HELSFIHH", finvoice.from_intermediator
    assert_equal "0987654321", finvoice.to_identifier
    assert_equal "BANKFIHH", finvoice.to_intermediator
    assert_equal "#{time_now.strftime("%Y%m%d%H%M%S")}-2013000018", finvoice.message_identifier
    assert_equal time_now.strftime("%Y-%m-%dT%H:%M:%S"), finvoice.message_time_stamp

    ########################
    ## SellerPartyDetails ##
    ########################

    assert_equal "9876543-0", finvoice.seller_party_identifier
    assert_equal "Acme Oy", finvoice.seller_organisation_name
    assert_equal "FI98765430", finvoice.seller_organisation_tax_code
    assert_equal "Asvalttikatu 99", finvoice.seller_street_name
    assert_equal "Helsinki", finvoice.seller_town_name
    assert_equal "00100", finvoice.seller_post_code_identifier
    assert_equal "FI", finvoice.seller_country_code
    assert_equal "FI", finvoice.seller_country_name
    assert_equal "Joe Danger", finvoice.seller_contact_person_name

    ##############################
    ## SellerInformationDetails ##
    ##############################

    assert_equal "Helsinki", finvoice.seller_home_town_name
    assert_equal "Alv.Rek", finvoice.seller_vat_registration_text
    assert_equal "", finvoice.seller_phone_number
    assert_equal "", finvoice.seller_fax_number
    assert_equal "", finvoice.seller_common_emailaddress_identifier
    assert_equal "", finvoice.seller_webaddress_identifier

    assert_equal 2, finvoice.seller_account_details.count
    assert_equal "FI4819503000000010", finvoice.seller_account_details.first.iban
    assert_equal "BANKFIHH", finvoice.seller_account_details.first.bic
    assert_equal "FI3819503000086423", finvoice.seller_account_details.last.iban
    assert_equal "BANKFIHH", finvoice.seller_account_details.last.bic

    #######################
    ## BuyerPartyDetails ##
    #######################

    assert_equal "7654321-2", finvoice.buyer_party_identifier
    assert_equal "Purjehdusseura Bitti ja Baatti ry", finvoice.buyer_organisation_name
    assert_equal "FI76543212", finvoice.buyer_organisation_tax_code
    assert_equal "Sempalokatu 2", finvoice.buyer_street_name
    assert_equal "Tampere", finvoice.buyer_town_name
    assert_equal "00122", finvoice.buyer_post_code_identifier
    assert_equal "FI", finvoice.buyer_country_code
    assert_equal "FI", finvoice.buyer_country_name
    assert_equal "", finvoice.buyer_organisation_unit_number
    assert_equal "", finvoice.buyer_contact_person_name
  end

  test 'should generate finvoice xml' do
    example = File.read Rails.root.join('test', 'assets', 'example_finvoice.xml')
    finvoice = Finvoice.new(invoice_id: @invoice.id).to_xml

    example = File.read Rails.root.join('test', 'assets', 'example_finvoice.xml')
    xml_example = Nokogiri::XML example
    xml_response = Nokogiri::XML finvoice

    # assert_equal xml_example.to_s, xml_response.to_s
    refute_empty finvoice
  end
end
