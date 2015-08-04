require 'test_helper'

class AccountHelperTest < ActionView::TestCase
  test "gives names" do
    assert_equal "Perustamismenot 120", account_name('120')
  end

  test "gives blank" do
    assert_equal "", account_name('not_a_account')
  end

  test "returns translated toimijaliitos options valid for collection" do
    assert toimijaliitos_options.is_a? Array

    text = I18n.t 'administration.accounts.toimijaliitos_options.relation_not_required', :fi
    assert_equal text, toimijaliitos_options.first.first
  end

  test "returns translated tiliointi_tarkistus options valid for collection" do
    assert tiliointi_tarkistus_options.is_a? Array

    text = I18n.t 'administration.accounts.tiliointi_tarkistus_options.no_mandatory_fields', :fi
    assert_equal text, tiliointi_tarkistus_options.first.first
  end

  test "returns translated manuaali_esto options valid for collection" do
    assert manuaali_esto_options.is_a? Array

    text = I18n.t 'administration.accounts.manuaali_esto_options.editing_enabled', :fi
    assert_equal text, manuaali_esto_options.first.first
  end
end
