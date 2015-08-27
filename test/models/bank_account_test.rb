require "test_helper"

class BankAccountTest < ActiveSupport::TestCase
  fixtures %w(bank_accounts)

  setup do
    @ba = bank_accounts(:acme_account)
  end

  test "fixtures should be valid" do
    assert @ba.valid?, @ba.errors.full_messages
  end

  test "duplicate accounts should fail" do
    two = @ba.dup
    refute two.valid?

    error = [:iban, I18n.t('errors.messages.taken')]
    assert_equal error, two.errors.first
  end

  test "should validate iban" do
    valid_ibans = %w(
      AL47212110090000000235698741
      CZ6508000000192000145399
      SE3550000000054910000003
      FI2112345600000785
    )

    valid_ibans.each do |iban|
      @ba.iban = iban
      @ba.tilino = nil
      assert @ba.valid?
    end

    @ba.iban = "not_a_valid_iban_123"
    refute @ba.valid?
  end

  test 'should skip all valiations if not a finnish company' do
    @ba.company.maa = 'SE'
    @ba.iban = "not_a_valid_iban_123"
    assert @ba.valid?

    @ba.tilino = "not_a_valid_tilino"
    assert @ba.valid?

    @ba.bic = "not_a_valid_bic"
    assert @ba.valid?
  end

  test "only text bypasses IBAN validation" do
    @ba.iban = "Keijon Kassatili"
    @ba.tilino = nil
    assert @ba.valid?
  end

  test "IBAN is converted to uniform format" do
    @ba.iban = "FI37-1590-3000-0007-76"

    assert @ba.valid?, @ba.errors.full_messages
    assert_equal "FI3715903000000776", @ba.iban
  end

  test 'should generate account number from iban' do
    @ba.iban = 'FI7329501800068417'
    @ba.tilino = nil

    assert @ba.valid?
    assert_equal '29501800068417', @ba.tilino
  end

  test 'should generate iban from account number' do
    @ba.tilino = "574044-25478"
    @ba.iban = nil

    assert @ba.valid?
    assert_equal 'FI0457404420005478', @ba.iban
  end

  test "validates BIC properly" do
    valid_bics = %w(OKOYFIHH AABAFI22 PSPBFIHH HANDFIHH)

    valid_bics.each do |bic|
      @ba.bic = bic
      assert @ba.valid?, @ba.errors.full_messages
    end

    invalid_bics = %w(kala kissa koira OKOYFKH PSPBFxh KEIJOBANK)

    invalid_bics.each do |bic|
      @ba.bic = bic
      refute @ba.valid?, @ba.errors.full_messages
    end
  end

  test "existence of all associated accounts is required" do
    @ba.oletus_rahatili = 9999
    refute @ba.valid?
  end

  test "existence of default liquidity account is required" do
    @ba.oletus_rahatili = 9999
    refute @ba.valid?
  end

  test "existence of default expense account is required" do
    @ba.oletus_kulutili = 9999
    refute @ba.valid?
  end

  test "existence of default clearing account is required" do
    @ba.oletus_selvittelytili = 9999
    refute @ba.valid?
  end

  test "default values" do
    @ba.oletus_kustp, @ba.oletus_kohde, @ba.oletus_projekti = nil
    @ba.save

    assert_equal @ba.reload.oletus_kustp, 0
    assert_equal @ba.reload.oletus_kohde, 0
    assert_equal @ba.reload.oletus_projekti, 0
  end
end
