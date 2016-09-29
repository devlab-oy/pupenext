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
        jarjestys: 7,
      },
    )
  end

  test '#copy' do
    copied_company = @copier.copy

    assert copied_company.valid?, copied_company.errors.full_messages
    assert copied_company.persisted?

    assert_equal 'FI',             copied_company.maa
    assert_equal 'acme',           copied_company.konserni
    assert_equal '95',             copied_company.yhtio
    assert_equal 'Kala Oy',        copied_company.nimi
    assert_equal 'Kalatie 2',      copied_company.osoite
    assert_equal '12345',          copied_company.postino
    assert_equal 'Kala',           copied_company.postitp
    assert_equal '1234567-8',      copied_company.ytunnus
    assert_equal 7,                copied_company.jarjestys

    acme_counts = OpenStruct.new(
      account:          Account.count,
      currency:         Currency.count,
      customer:         Customer.count,
      delivery_method:  DeliveryMethod.count,
      keyword:          Keyword.count,
      menu:             Menu.count,
      printer:          Printer.count,
      profile:          UserProfile.count,
      sum_level:        SumLevel.count,
      terms_of_payment: TermsOfPayment.count,
      warehouse:        Warehouse.count,
    )

    Current.company = copied_company

    assert_empty copied_company.parameter.finvoice_senderpartyid
    assert_equal '* { font-family: sans-serif }', copied_company.parameter.css

    assert_includes copied_company.currencies.pluck(:nimi), 'EUR'

    assert_equal 'Hae ja selaa',   copied_company.menus.first.nimitys
    assert_equal 'Admin profiili', copied_company.user_profiles.first.profiili
    assert_equal 3,                copied_company.users.count
    assert_equal 'admin',          copied_company.users.first.kuka

    assert_equal acme_counts.account,          copied_company.accounts.count
    assert_equal acme_counts.currency,         copied_company.currencies.count
    assert_equal acme_counts.customer,         copied_company.customers.count
    assert_equal acme_counts.delivery_method,  copied_company.delivery_methods.count
    assert_equal acme_counts.keyword,          copied_company.keywords.count
    assert_equal acme_counts.menu,             copied_company.menus.count
    assert_equal acme_counts.printer,          copied_company.printers.count
    assert_equal acme_counts.profile,          copied_company.user_profiles.count
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
      'Menu.unscoped.count',
      'Parameter.unscoped.count',
      'Printer.unscoped.count',
      'SumLevel.unscoped.count',
      'TermsOfPayment.unscoped.count',
      'User.unscoped.count',
      'UserProfile.unscoped.count',
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
      'Menu.unscoped.count',
      'Parameter.unscoped.count',
      'Printer.unscoped.count',
      'SumLevel.unscoped.count',
      'TermsOfPayment.unscoped.count',
      'User.unscoped.count',
      'UserProfile.unscoped.count',
      'Warehouse.unscoped.count',
    ] do
      assert copier.copy.invalid?
    end
  end

  test '#copy allows different company to be copied than current company' do
    Current.company = companies(:estonian)

    esto_counts = OpenStruct.new(
      account:          Account.count,
      currency:         Currency.count,
      customer:         Customer.count,
      delivery_method:  DeliveryMethod.count,
      keyword:          Keyword.count,
      menu:             Menu.count,
      printer:          Printer.count,
      profile:          UserProfile.count,
      sum_level:        SumLevel.count,
      terms_of_payment: TermsOfPayment.count,
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

    assert_equal 2,                            copied_company.users.count
    assert_equal 'admin',                      copied_company.users.first.kuka

    assert_equal esto_counts.account,          copied_company.accounts.count
    assert_equal esto_counts.currency,         copied_company.currencies.count
    assert_equal esto_counts.customer,         copied_company.customers.count
    assert_equal esto_counts.delivery_method,  copied_company.delivery_methods.count
    assert_equal esto_counts.keyword,          copied_company.keywords.count
    assert_equal esto_counts.menu,             copied_company.menus.count
    assert_equal esto_counts.printer,          copied_company.printers.count
    assert_equal esto_counts.profile,          copied_company.user_profiles.count
    assert_equal esto_counts.sum_level,        copied_company.sum_levels.count
    assert_equal esto_counts.terms_of_payment, copied_company.terms_of_payments.count
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
            kieli: 'fi',
          },
          {
            kuka: 'second-user@example.com',
            nimi: 'Secuser',
            salasana: 'bar',
            kieli: 'fi',
          },
        ],
      },
      customer_companies: [estonian.yhtio],
    ).copy
    assert copier.valid?, copier.errors.full_messages

    Current.company = estonian
    customer = estonian.customers.find_by(nimi: 'Kala Oy Esimerkki')
    assert_not_nil customer
    assert_equal 'extranet-user@example.com, second-user@example.com', customer.email

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
            kieli: 'fi',
            kuka: 'erkki.eka@example.com',
            nimi: 'Erkki',
            profiilit: 'Admin profiili',
            salasana: kissa_pass,
          },
          {
            kieli: 'fi',
            kuka: 'totti.toka@example.com',
            nimi: 'Totti',
            profiilit: 'Admin profiili',
            salasana: koira_pass,
          },
        ],
      },
    ).copy

    Current.company = copier
    assert copier.valid?
    assert_equal users_count, User.count

    erkki = copier.users.find_by kuka: 'erkki.eka@example.com'
    assert erkki.valid?
    assert_equal 'Erkki',          erkki.nimi
    assert_equal 'Admin profiili', erkki.profiilit
    assert_equal kissa_pass,       erkki.salasana
    assert_not_empty               erkki.permissions

    totti = copier.users.find_by kuka: 'totti.toka@example.com'
    assert totti.valid?
    assert_equal 'Totti',          totti.nimi
    assert_equal 'Admin profiili', totti.profiilit
    assert_equal koira_pass,       totti.salasana
    assert_not_empty               totti.permissions
  end
end
