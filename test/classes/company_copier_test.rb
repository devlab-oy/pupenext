require 'test_helper'

class CompanyCopierTest < ActiveSupport::TestCase
  fixtures :all

  setup do
    @copier = CompanyCopier.new(company: companies(:acme), yhtio: 95, nimi: 'Kala Oy')
  end

  test '#copy' do
    Current.user = users(:bob)

    copied_company = nil

    assert_difference 'Company.count' do
      assert_difference 'Parameter.unscoped.count' do
        assert_difference 'Currency.unscoped.count' do
          assert_difference 'Permission.unscoped.count', 40 do
            assert_difference 'User.unscoped.count' do
              assert_difference 'SumLevel.unscoped.count', 10 do
                assert_difference 'Account.unscoped.count', 52 do
                  assert_difference 'Keyword.unscoped.count', 29 do
                    assert_difference 'Printer.unscoped.count', 2 do
                      assert_difference 'TermsOfPayment.unscoped.count', 8 do
                        assert_difference 'DeliveryMethod.unscoped.count', 4 do
                          copied_company = @copier.copy
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end

    assert copied_company.persisted?

    assert_equal 'FI', copied_company.maa

    assert_empty copied_company.konserni

    assert_equal '95', copied_company.yhtio
    assert_equal 'Kala Oy', copied_company.nimi
    assert_equal users(:bob).kuka, copied_company.laatija
    assert_equal users(:bob).kuka, copied_company.muuttaja

    Current.company = copied_company

    refute_nil copied_company.parameter
    refute_empty copied_company.currencies
    refute_empty copied_company.menus
    refute_empty copied_company.profiles
    refute_empty copied_company.users
    refute_empty copied_company.users.first.permissions
    refute_empty copied_company.sum_levels
    refute_empty copied_company.accounts
    refute_empty copied_company.keywords
    refute_empty copied_company.printers
    refute_empty copied_company.terms_of_payments
    refute_empty copied_company.delivery_methods
  end
end
