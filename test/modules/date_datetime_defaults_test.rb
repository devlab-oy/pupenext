require 'test_helper'

class DateDatetimeDefaultsTest < ActiveSupport::TestCase
  setup do
    @valid_datetime   = '2012-10-20 05:40:50'
    @zero_datetime    = '0000-00-00 00:00:00'

    @valid_date   = '2012-10-20'
    @zero_date    = '0000-00-00'

    Current.user = users :bob
  end

  test 'date fields are set to zero on create' do
    # create with valid time
    head = SalesOrder::Order.create! erpcm: @valid_date
    assert_equal @valid_date, head.erpcm_before_type_cast

    # create with zero time.
    # even without typecast, rails gives value 0, but it's *really* '0000-00-00' in the db
    head = SalesOrder::Order.create! erpcm: @zero_date
    assert_equal 0, head.erpcm_before_type_cast

    # create without time
    # even without typecast, rails gives value 0, but it's *really* '0000-00-00' in the db
    head = SalesOrder::Order.create! erpcm: nil
    assert_equal 0, head.erpcm_before_type_cast
  end

  test 'date fields are set to zero on update' do
    # update with valid time
    head = SalesOrder::Order.create! erpcm: nil
    head.update! erpcm: @valid_date
    assert_equal @valid_date, head.erpcm_before_type_cast

    # update with zero time
    # even without typecast, rails gives value 0, but it's *really* '0000-00-00' in the db
    head = SalesOrder::Order.create! erpcm: @valid_date
    head.update! erpcm: @zero_date
    assert_equal 0, head.erpcm_before_type_cast

    # update without time
    head = SalesOrder::Order.create! erpcm: @valid_date
    head.update! erpcm: nil
    # even without typecast, rails gives value 0, but it's *really* '0000-00-00' in the db
    assert_equal 0, head.erpcm_before_type_cast
  end

  test 'datetime fields are set to zero on create' do
    # create with valid time
    head = SalesOrder::Order.create! h1time: @valid_datetime
    assert_equal @valid_datetime, head.h1time_before_type_cast

    # create with zero time
    head = SalesOrder::Order.create! h1time: @zero_datetime
    assert_equal @zero_datetime, head.h1time_before_type_cast

    # create without time
    head = SalesOrder::Order.create! h1time: nil
    assert_equal @zero_datetime, head.h1time_before_type_cast
  end

  test 'datetime fields are set to zero on update' do
    # update with valid time
    head = SalesOrder::Order.create! h1time: nil
    head.update! h1time: @valid_datetime
    assert_equal @valid_datetime, head.h1time_before_type_cast

    # update with zero time
    head = SalesOrder::Order.create! h1time: @valid_datetime
    head.update! h1time: @zero_datetime
    assert_equal @zero_datetime, head.h1time_before_type_cast

    # update without time
    head = SalesOrder::Order.create! h1time: @valid_datetime
    head.update! h1time: nil
    assert_equal @zero_datetime, head.h1time_before_type_cast
  end

  test 'date fields with default null are not set to zero on create' do
    terms_of_payment = TermsOfPayment.create! teksti: 'Testimaksuehto', abs_pvm: nil
    assert_nil terms_of_payment.abs_pvm

    terms_of_payment = TermsOfPayment.create! teksti: 'Testimaksuehto', abs_pvm: @valid_date
    assert_equal @valid_date, terms_of_payment.read_attribute_before_type_cast(:abs_pvm)
  end

  test 'date fields with default null are not set to zero on update' do
    terms_of_payment = TermsOfPayment.create! teksti: 'Testimaksuehto', abs_pvm: nil
    terms_of_payment.update! abs_pvm: @valid_date
    assert_equal @valid_date, terms_of_payment.read_attribute_before_type_cast(:abs_pvm)

    terms_of_payment = TermsOfPayment.create! teksti: 'Testimaksuehto', abs_pvm: @valid_date
    terms_of_payment.update! abs_pvm: nil
    assert_nil terms_of_payment.abs_pvm
  end

  test 'datetime fields with default null are not set to zero on create' do
    spi = SupplierProductInformation.create! product_id: '123', p_added_date: nil
    assert_nil spi.p_added_date

    spi = SupplierProductInformation.create! product_id: '123', p_added_date: @valid_datetime
    assert_equal @valid_datetime, spi.read_attribute_before_type_cast(:p_added_date)
  end

  test 'datetime fields with default null are not set to zero on update' do
    spi = SupplierProductInformation.create! product_id: '123', p_added_date: nil
    spi.update! p_added_date: @valid_datetime
    assert_equal @valid_datetime, spi.read_attribute_before_type_cast(:p_added_date)

    spi = SupplierProductInformation.create! product_id: '123', p_added_date: @valid_datetime
    spi.update! p_added_date: nil
    assert_nil spi.p_added_date
  end

  test 'datetime defaults do not overried created_at/updated_at' do
    spi = SupplierProductInformation.create! product_id: '123'
    assert_nil spi.p_added_date
    assert_not_nil spi.created_at
    assert_not_nil spi.updated_at

    product = Product.new
    product.save(validate: false)

    assert_not_equal @zero_datetime, product.luontiaika_before_type_cast
    assert_not_equal @zero_datetime, product.muutospvm_before_type_cast
  end
end
