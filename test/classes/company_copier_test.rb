require 'test_helper'

class CompanyCopierTest < ActiveSupport::TestCase
  fixtures :all

  setup do
    Current.user = users :bob
    @company = companies :acme

    @copier = CompanyCopier.new(
      from_company: @company,
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
    assert_equal 'acme',           copied_company.konserni
    assert_equal '95',             copied_company.yhtio
    assert_equal 'Kala Oy',        copied_company.nimi
    assert_equal 'Kalatie 2',      copied_company.osoite
    assert_equal '12345',          copied_company.postino
    assert_equal 'Kala',           copied_company.postitp
    assert_equal '1234567-8',      copied_company.ytunnus

    acme_counts = OpenStruct.new(
      account:          Account.count,
      currency:         Currency.count,
      customer:         Customer.count,
      delivery_method:  DeliveryMethod.count,
      keyword:          Keyword.count,
      menu:             Permission.where(kuka: '').where(profiili: '').count,
      permission:       Permission.count,
      printer:          Printer.count,
      profile:          Permission.where.not(profiili: '').where('profiili = kuka').count,
      sum_level:        SumLevel.count,
      terms_of_payment: TermsOfPayment.count,
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

    assert_equal 3,       copied_company.users.count
    assert_equal 'admin', copied_company.users.first.kuka

    assert_equal acme_counts.account,          copied_company.accounts.count
    assert_equal acme_counts.customer,         copied_company.customers.count
    assert_equal acme_counts.delivery_method,  copied_company.delivery_methods.count
    assert_equal acme_counts.keyword,          copied_company.keywords.count
    assert_equal acme_counts.permission,       copied_company.permissions.count
    assert_equal acme_counts.printer,          copied_company.printers.count
    assert_equal acme_counts.sum_level,        copied_company.sum_levels.count
    assert_equal acme_counts.terms_of_payment, copied_company.terms_of_payments.count
    assert_equal acme_counts.warehouse,        copied_company.warehouses.count
  end

  test '#copy destroys all copied data if anything goes wrong' do
    Account.any_instance.stubs(:save!).raises(StandardError)

    assert_no_difference [
      'Account.unscoped.count',
      'Company.unscoped.count',
      'Currency.unscoped.count',
      'Customer.unscoped.count',
      'DeliveryMethod.unscoped.count',
      'Keyword.unscoped.count',
      'Parameter.unscoped.count',
      'Permission.unscoped.count',
      'Printer.unscoped.count',
      'SumLevel.unscoped.count',
      'TermsOfPayment.unscoped.count',
      'User.unscoped.count',
      'Warehouse.unscoped.count',
    ] do
      assert_raise StandardError do
        @copier.copy
      end
    end

    # make sure we delete the correct company at the end
    assert_nil Company.find_by(nimi: 'Kala Oy')
    assert_not_nil Company.find_by(nimi: @company.nimi)
  end

  test '#copy handles duplicate yhtio correctly' do
    copier = CompanyCopier.new(
      from_company: @company,
      to_company_params: { yhtio: 'acme', nimi: 'Kala Oy' },
    )

    assert_no_difference [
      'Account.unscoped.count',
      'Company.unscoped.count',
      'Currency.unscoped.count',
      'Customer.unscoped.count',
      'DeliveryMethod.unscoped.count',
      'Keyword.unscoped.count',
      'Parameter.unscoped.count',
      'Permission.unscoped.count',
      'Printer.unscoped.count',
      'SumLevel.unscoped.count',
      'TermsOfPayment.unscoped.count',
      'User.unscoped.count',
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
      permission:       Permission.count,
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
    assert_equal 2,                            copied_company.users.count
    assert_equal 'admin',                      copied_company.users.first.kuka
    assert_equal esto_counts.permission,       copied_company.permissions.count
    assert_equal esto_counts.sum_level,        copied_company.sum_levels.count
    assert_equal esto_counts.account,          copied_company.accounts.count
    assert_equal esto_counts.keyword,          copied_company.keywords.count
    assert_equal esto_counts.printer,          copied_company.printers.count
    assert_equal esto_counts.terms_of_payment, copied_company.terms_of_payments.count
    assert_equal esto_counts.delivery_method,  copied_company.delivery_methods.count
    assert_equal esto_counts.warehouse,        copied_company.warehouses.count
  end

  test 'Current.company is returned to original in any case' do
    current_company = @company

    copier = CompanyCopier.new(
      from_company: companies(:estonian),
      to_company_params: { yhtio: 'kala', nimi: 'Kala Oy' },
    )
    copied_company = copier.copy
    assert copied_company.valid?, copied_company.errors.full_messages
    assert_equal current_company, @company

    copier = CompanyCopier.new(
      from_company: @company,
      to_company_params: { yhtio: 'acme', nimi: 'Kala Oy' },
    )
    copier.copy
    assert_equal current_company, @company

    Account.all.update_all(nimi: '')
    @copier.copy
    assert_equal current_company, @company
  end

  test 'company is created as customer to companies passed in customer_companies' do
    estonian = companies(:estonian)

    # create new company 'Kala Oy', and create it as a customer to estonian -company
    # create all users also as extranet users to estonian -company
    copier = CompanyCopier.new(
      from_company: @company,
      to_company_params: {
        yhtio: 95,
        nimi: 'Kala Oy Esimerkki',
        osoite: 'Kalatie 2',
        postino: '12345',
        postitp: 'Kala',
        ytunnus: '1234567-8',
        users_attributes: [
          {
            kuka: 'extranet-user@example.com',
            nimi: 'Euser',
            salasana: 'foo',
          },
        ],
      },
      customer_companies: [estonian.yhtio],
    ).copy
    assert copier.valid?, copier.errors.full_messages

    Current.company = estonian
    assert_not_nil estonian.customers.find_by(nimi: 'Kala Oy Esimerkki')

    user = estonian.users.find_by(kuka: 'extranet-user@example.com')
    assert_not_nil user
    assert_equal 'X', user.extranet
    assert_equal 'Extranet', user.profiilit
    assert_equal 'Extranet', user.oletus_profiili
  end

  test 'users are created for companies' do
    kissa_pass = Digest::MD5.hexdigest('kissa')
    koira_pass = Digest::MD5.hexdigest('koira')
    users_count = @company.users.count + 2

    copier = CompanyCopier.new(
      from_company: @company,
      to_company_params: {
        yhtio: 95,
        nimi: 'Kala Oy',
        osoite: 'Kalatie 2',
        postino: '12345',
        postitp: 'Kala',
        ytunnus: '1234567-8',
        users_attributes: [
          {
            kuka: 'erkki.eka@example.com',
            nimi: 'Erkki',
            salasana: kissa_pass,
          },
          {
            kuka: 'totti.toka@example.com',
            nimi: 'Totti',
            salasana: koira_pass,
          },
        ],
      },
    ).copy

    Current.company = copier
    assert copier.valid?
    assert_equal users_count, User.count

    assert_equal 'erkki.eka@example.com', User.first.kuka
    assert_equal 'Erkki',                 User.first.nimi
    assert_equal kissa_pass,              User.first.salasana

    assert_equal 'totti.toka@example.com', User.second.kuka
    assert_equal 'Totti',                  User.second.nimi
    assert_equal koira_pass,               User.second.salasana
  end
end
