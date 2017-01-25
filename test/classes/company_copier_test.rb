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
    @copier.copy

    assert @copier.errors.empty?, @copier.errors
    assert @copier.copied_company.persisted?
    copied_company = @copier.copied_company

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

    [0, 1, 2, 3, 4, 5, 6, 7, 9, 10].each do |number|
      assert_equal Printer.first, Printer.find(copied_company.warehouses.first.send("printteri#{number}").id)
    end

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
    Account.any_instance.stubs(:valid?).returns(false)

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
      'BankAccount.unscoped.count',
    ] do
      @copier.copy
      assert @copier.errors.present?
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
      copier.copy
      assert copier.errors.present?
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

    copier.copy
    assert copier.errors.empty?, copier.errors

    copied_company = copier.copied_company
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
    assert copied_company.errors.empty?, copied_company.errors
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
          {
            kuka: 'second-user@example.com',
            nimi: 'Secuser',
            salasana: 'bar',
          },
        ],
      },
      customer_companies: [estonian.yhtio],
    ).copy
    assert copier.errors.empty?, copier.errors

    Current.company = estonian
    customer = estonian.customers.find_by(nimi: 'Kala Oy Esimerkki')
    assert_not_nil customer
    assert_equal 'extranet-user@example.com', customer.email

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
            profiilit: 'Admin profiili',
            salasana: kissa_pass,
          },
          {
            kuka: 'totti.toka@example.com',
            nimi: 'Totti',
            profiilit: 'Admin profiili',
            salasana: koira_pass,
          },
        ],
      },
    ).copy

    copied_company = copier.copied_company
    Current.company = copied_company
    assert copier.errors.empty?
    assert_equal users_count, User.count

    erkki = copied_company.users.find_by kuka: 'erkki.eka@example.com'
    assert erkki.valid?
    assert_equal 'Erkki',          erkki.nimi
    assert_equal 'Admin profiili', erkki.profiilit
    assert_equal kissa_pass,       erkki.salasana
    assert_not_empty               erkki.permissions

    totti = copied_company.users.find_by kuka: 'totti.toka@example.com'
    assert totti.valid?
    assert_equal 'Totti',          totti.nimi
    assert_equal 'Admin profiili', totti.profiilit
    assert_equal koira_pass,       totti.salasana
    assert_not_empty               totti.permissions
  end

  test 'company is created as supplier to companies passed in supplier_companies' do
    estonian = companies(:estonian)
    Current.company = estonian
    count = estonian.suppliers.count

    # create new company 'Kala Oy', and create it as a supplier to estonian -company
    copier = CompanyCopier.new(
      from_company: @company,
      supplier_companies: [estonian.yhtio],
      to_company_params: {
        yhtio: 95,
        nimi: 'Kala Oy Esimerkki',
        osoite: 'Kalatie 2',
        postino: '12345',
        postitp: 'Kala',
        ytunnus: '1234567-8',
        bank_accounts_attributes: [
          {
            nimi: 'Ainopankki',
            tilino: '12345600000785',
            oletus_kulutili: '300',
            oletus_rahatili: '300',
            oletus_selvittelytili: '300',
            iban: 'FI2112345600000785',
            valkoodi: 'EUR',
            bic: 'AINOFIHH',
          },
        ],
        users_attributes: [
          {
            kuka: 'extranet-user@example.com',
            nimi: 'Euser',
            salasana: 'foo',
          },
        ],
      },
    )

    assert_difference 'Company.count' do
      copier.copy
    end

    supplier = estonian.suppliers.find_by(nimi: 'Kala Oy Esimerkki')
    assert_not_nil supplier
    assert_equal 'extranet-user@example.com', supplier.email
    assert count + 1, estonian.suppliers.reload.count
  end

  test 'supplier creation invalid data' do
    estonian = companies(:estonian)
    Current.company = estonian
    count = estonian.suppliers.count

    # create new company 'Kala Oy', and create it as a supplier to estonian -company
    # bank_accounts_attributes iban and bic are required
    copier = CompanyCopier.new(
      from_company: @company,
      supplier_companies: [estonian.yhtio],
      to_company_params: {
        yhtio: 95,
        nimi: 'Kala Oy Esimerkki',
        osoite: 'Kalatie 2',
        postino: '12345',
        postitp: 'Kala',
        ytunnus: '1234567-8',
        bank_accounts_attributes: [],
        users_attributes: [
          {
            kuka: 'extranet-user@example.com',
            nimi: 'Euser',
            salasana: 'foo',
          },
        ],
      },
    )

    assert_difference 'Company.count' do
      copier.copy
    end

    assert count, estonian.suppliers.reload.count
  end
end
