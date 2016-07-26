require 'test_helper'

class CompanyCopierTest < ActiveSupport::TestCase
  fixtures :all

  setup do
    Current.company = companies(:acme)
    Current.user    = users(:bob)

    @copier = CompanyCopier.new(
      to_company_params: {
        yhtio: 95,
        nimi: 'Kala Oy',
        osoite: 'Kalatie 2',
        postino: '12345',
        postitp: 'Kala',
        ytunnus: '1234567-8',
      },
    )
  end

  test '#copy' do
    copied_company = @copier.copy

    assert copied_company.valid?
    assert copied_company.persisted?

    assert_equal 'FI',             copied_company.maa
    assert_equal '',               copied_company.konserni
    assert_equal '95',             copied_company.yhtio
    assert_equal 'Kala Oy',        copied_company.nimi
    assert_equal 'Kalatie 2',      copied_company.osoite
    assert_equal '12345',          copied_company.postino
    assert_equal 'Kala',           copied_company.postitp
    assert_equal '1234567-8',      copied_company.ytunnus
    assert_equal users(:bob).kuka, copied_company.laatija
    assert_equal users(:bob).kuka, copied_company.muuttaja

    acme_counts = OpenStruct.new(
      sum_level:        SumLevel.count,
      currency:         Currency.count,
      menu:             Permission.where(kuka: '').where(profiili: '').count,
      profile:          Permission.where.not(profiili: '').where('profiili = kuka').count,
      permission:       User.find_by!(kuka: 'admin').permissions.count,
      account:          Account.count,
      keyword:          Keyword.count,
      printer:          Printer.count,
      terms_of_payment: TermsOfPayment.count,
      delivery_method:  DeliveryMethod.count,
      warehouse:        Warehouse.count,
    )

    Current.company = copied_company

    assert_empty copied_company.parameter.finvoice_senderpartyid
    assert_equal '* { font-family: sans-serif }', copied_company.parameter.css

    assert_equal acme_counts.currency, copied_company.currencies.count
    assert_includes copied_company.currencies.pluck(:nimi), 'EUR'

    assert_equal acme_counts.menu, copied_company.menus.count
    assert_equal 'Hae ja selaa',   copied_company.menus.first.nimitys

    assert_equal acme_counts.profile, copied_company.profiles.count
    assert_equal 'Admin profiili',    copied_company.profiles.first.profiili

    assert_equal 1,       copied_company.users.count
    assert_equal 'admin', copied_company.users.first.kuka

    assert_equal acme_counts.permission,       copied_company.users.first.permissions.count
    assert_equal acme_counts.sum_level,        copied_company.sum_levels.count
    assert_equal acme_counts.account,          copied_company.accounts.count
    assert_equal acme_counts.keyword,          copied_company.keywords.count
    assert_equal acme_counts.printer,          copied_company.printers.count
    assert_equal acme_counts.terms_of_payment, copied_company.terms_of_payments.count
    assert_equal acme_counts.delivery_method,  copied_company.delivery_methods.count
    assert_equal acme_counts.warehouse,        copied_company.warehouses.count
  end

  test '#copy destroys all copied data if anything goes wrong' do
    Account.any_instance.stubs(:save!).raises(StandardError)

    assert_no_difference [
      'Company.unscoped.count',
      'User.unscoped.count',
      'Parameter.unscoped.count',
      'Currency.unscoped.count',
      'Permission.unscoped.count',
      'SumLevel.unscoped.count',
      'Account.unscoped.count',
      'Keyword.unscoped.count',
      'Printer.unscoped.count',
      'TermsOfPayment.unscoped.count',
      'DeliveryMethod.unscoped.count',
      'Warehouse.unscoped.count',
    ] do
      assert_raise StandardError do
        @copier.copy
      end
    end
  end

  test '#copy handles duplicate yhtio correctly' do
    copier = CompanyCopier.new(to_company_params: { yhtio: 'acme', nimi: 'Kala Oy' })

    assert_no_difference [
      'Company.unscoped.count',
      'User.unscoped.count',
      'Parameter.unscoped.count',
      'Currency.unscoped.count',
      'Permission.unscoped.count',
      'SumLevel.unscoped.count',
      'Account.unscoped.count',
      'BankAccount.unscoped.count',
      'Keyword.unscoped.count',
      'Printer.unscoped.count',
      'TermsOfPayment.unscoped.count',
      'DeliveryMethod.unscoped.count',
      'Warehouse.unscoped.count',
    ] do
      assert copier.copy.invalid?
    end
  end

  test '#copy allows different company to be copied than current company' do
    Current.company = companies(:estonian)

    esto_counts = OpenStruct.new(
      sum_level:        SumLevel.count,
      currency:         Currency.count,
      menu:             Permission.where(kuka: '').where(profiili: '').count,
      profile:          Permission.where.not(profiili: '').where('profiili = kuka').count,
      permission:       User.find_by!(kuka: 'admin').permissions.count,
      account:          Account.count,
      keyword:          Keyword.count,
      printer:          Printer.count,
      terms_of_payment: TermsOfPayment.count,
      delivery_method:  DeliveryMethod.count,
      warehouse:        Warehouse.count,
    )

    Current.company = companies(:acme)

    copier = CompanyCopier.new(
      from_company: companies(:estonian),
      to_company_params: { yhtio: 'kala', nimi: 'Kala Oy' },
    )

    copied_company = copier.copy
    assert copied_company.valid?, copied_company.errors.full_messages

    Current.company = copied_company

    assert_equal esto_counts.currency,         copied_company.currencies.count
    assert_equal esto_counts.menu,             copied_company.menus.count
    assert_equal esto_counts.profile,          copied_company.profiles.count
    assert_equal 1,                            copied_company.users.count
    assert_equal 'admin',                      copied_company.users.first.kuka
    assert_equal esto_counts.permission,       copied_company.users.first.permissions.count
    assert_equal esto_counts.sum_level,        copied_company.sum_levels.count
    assert_equal esto_counts.account,          copied_company.accounts.count
    assert_equal esto_counts.keyword,          copied_company.keywords.count
    assert_equal esto_counts.printer,          copied_company.printers.count
    assert_equal esto_counts.terms_of_payment, copied_company.terms_of_payments.count
    assert_equal esto_counts.delivery_method,  copied_company.delivery_methods.count
    assert_equal esto_counts.warehouse,        copied_company.warehouses.count
  end

  test 'Current.company is returned to original in any case' do
    current_company = Current.company

    copier = CompanyCopier.new(
      from_company: companies(:estonian),
      to_company_params: { yhtio: 'kala', nimi: 'Kala Oy' },
    )
    copied_company = copier.copy
    assert copied_company.valid?, copied_company.errors.full_messages
    assert_equal current_company, Current.company

    copier = CompanyCopier.new(to_company_params: { yhtio: 'acme', nimi: 'Kala Oy' })
    copier.copy
    assert_equal current_company, Current.company

    Account.all.update_all(nimi: '')
    @copier.copy
    assert_equal current_company, Current.company
  end

  test 'company can be created as customer to specified companies' do
    copier = CompanyCopier.new(
      to_company_params: {
        yhtio: 95,
        nimi: 'Kala Oy',
        osoite: 'Kalatie 2',
        postino: '12345',
        postitp: 'Kala',
        ytunnus: '1234567-8',
      },
      create_as_customer_to_ids: [companies(:estonian).id],
    )

    record = copier.copy

    assert record.valid?, record.errors.full_messages

    Current.company = companies(:estonian)

    assert_equal 1, Customer.count
    assert_equal 'Kala Oy', Customer.first.nimi
  end
end
