require 'test_helper'

class DateDatetimeDefaultsTest < ActiveSupport::TestCase
  fixtures %w(
    heads
    supplier_product_informations
    terms_of_payments
  )

  test 'date fields are set to zero by default correctly' do
    head = Head.create!(tila: 'N')

    assert_equal 0,                    head.erpcm
    assert_equal '2016-01-02'.to_date, heads(:si_one).erpcm
  end

  test 'datetime fields are set to zero by default correctly' do
    head = Head.create!(tila: 'N')

    assert_equal '0000-00-00 00:00:00',                  head.h1time
    assert_equal Time.zone.local(2016, 1, 2, 12, 0, 12), heads(:si_one).h1time
  end

  test 'date fields with default values are not set to zero' do
    terms_of_payment = TermsOfPayment.create!(teksti: 'Testimaksuehto')

    assert_nil terms_of_payment.kassa_abspvm
    assert_nil terms_of_payment.abs_pvm
  end

  test 'datetime fields with default values are not set to zero' do
    supplier_product_information = SupplierProductInformation.create!(product_id: '123')

    assert_nil supplier_product_information.p_added_date
  end
end
