require 'test_helper'

class CompanyCopierTest < ActiveSupport::TestCase
  fixtures :all

  setup do
    Current.company = companies(:acme)
    Current.user    = users(:bob)

    @copier = CompanyCopier.new(yhtio: 95, nimi: 'Kala Oy')
  end

  test '#copy' do
    copied_company = @copier.copy

    assert copied_company.persisted?

    assert_equal 'FI',             copied_company.maa
    assert_equal '',               copied_company.konserni
    assert_equal '95',             copied_company.yhtio
    assert_equal 'Kala Oy',        copied_company.nimi
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
    Account.all.update_all(nimi: '')

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
      assert_raise ActiveRecord::RecordInvalid do
        @copier.copy
      end
    end
  end
end
