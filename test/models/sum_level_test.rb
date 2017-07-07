require "test_helper"

class SumLevelTest < ActiveSupport::TestCase
  fixtures %w(sum_levels accounts)

  setup do
    @internal = sum_levels(:internal)
    @internal2 = sum_levels(:internal2)
    @internal3 = sum_levels(:internal3)
    @external = sum_levels(:external)
    @external2 = sum_levels(:external2)
    @vat = sum_levels(:vat)
    @profit = sum_levels(:profit)
    @commodity = sum_levels(:commodity)
  end

  test "fixtures should be valid" do
    refute_empty SumLevel.all

    SumLevel.all.each do |sum_level|
      assert sum_level.valid?, "SumLevel #{sum_level.nimi}: #{sum_level.errors.full_messages}"
    end
  end

  test "should return sum level name" do
    assert_equal "3 - TILIKAUDEN TULOS", @external.sum_level_name
  end

  test "sum level should not contain O with dots" do
    @internal.taso = "1Ö"
    refute @internal.valid?, @internal.errors.full_messages

    @internal.taso = "1ö"
    assert @internal.valid?, @internal.errors.full_messages

    @internal.taso = "1Ö"
    refute @internal.valid?, @internal.errors.full_messages

    @internal.taso = "1ö"
    assert @internal.valid?, @internal.errors.full_messages

    @external.taso = "1Ö"
    refute @external.valid?, @external.errors.full_messages

    @profit.taso = "1Ö"
    refute @profit.valid?, @profit.errors.full_messages

    @vat.taso = "1Ö"
    refute @vat.valid?, @vat.errors.full_messages
  end

  test "internal and external sum level needs to begin with 1 or 2 or 3" do
    @internal.taso = "4"
    refute @internal.valid?, @internal.errors.full_messages

    @external.taso = "4"
    refute @external.valid?, @external.errors.full_messages

    @internal.taso = "14"
    assert @internal.valid?, @internal.errors.full_messages

    @external.taso = "114"
    assert @external.valid?, @external.errors.full_messages

    @external.taso = "213"
    assert @external.valid?, @external.errors.full_messages

    @external.taso = "3"
    assert @external.valid?, @external.errors.full_messages

    @external.taso = 3
    assert @external.valid?, @external.errors.full_messages
  end

  test "profit sum level needs to be number" do
    @profit.taso = "A"
    refute @profit.valid?, @profit.errors.full_messages

    @profit.taso = "A1"
    refute @profit.valid?, @profit.errors.full_messages

    @profit.taso = 1.0
    refute @profit.valid?, @profit.errors.full_messages

    @profit.taso = ""
    refute @profit.valid?, @profit.errors.full_messages

    @profit.taso = nil
    refute @profit.valid?, @profit.errors.full_messages

    @profit.taso = 1
    assert @profit.valid?, @profit.errors.full_messages

    @profit.taso = 0
    assert @profit.valid?, @profit.errors.full_messages

    @profit.taso = "1"
    assert @profit.valid?, @profit.errors.full_messages

    @profit.taso = "0"
    assert @profit.valid?, @profit.errors.full_messages

    @profit.taso = "00"
    assert @profit.valid?, @profit.errors.full_messages
  end

  test "commodity sum level can be a letter" do
    @commodity.taso = 'C'
    assert @commodity.valid?, @commodity.errors.full_messages
  end

  test "should have unique sum level in scope" do
    # taso should be unique in scope [:yhtio, :tyyppi]
    new_sum_level = @internal.dup
    refute new_sum_level.valid?

    error_message = [:taso, I18n.t('errors.messages.taken')]
    assert_equal error_message, new_sum_level.errors.first

    # changing the company makes it valid
    new_sum_level.yhtio = 'esto'
    assert new_sum_level.valid?

    # or changing the taso makes it valid
    new_sum_level.yhtio = @internal.yhtio
    new_sum_level.taso = '1 something different'
    assert new_sum_level.valid?
  end

  test "taso should be present" do
    @internal.taso = ""
    refute @internal.valid?, @internal.errors.full_messages

    @internal.taso = nil
    refute @internal.valid?, @internal.errors.full_messages

    @internal.taso = "1"
    assert @internal.valid?, @internal.errors.full_messages
  end

  test "nimi should be present" do
    @internal.nimi = ""
    refute @internal.valid?, @internal.errors.full_messages

    @internal.nimi = nil
    refute @internal.valid?, @internal.errors.full_messages

    @internal.nimi = "Liikevaihto"
    assert @internal.valid?, @internal.errors.full_messages
  end

  test "internal external and vat should be able to have summattava_taso" do
    @internal.summattava_taso = "taso_not_in_db"
    refute @internal.valid?, @internal.errors.full_messages

    @internal.summattava_taso = "taso_not_in_db,also_not_in_db"
    refute @internal.valid?, @internal.errors.full_messages

    #summattava_taso also needs to be same type as the _current_ taso
    @internal.summattava_taso = @internal2.taso
    assert @internal.valid?, @internal.errors.full_messages

    @internal.summattava_taso = "#{@internal2.taso},#{@internal3.taso}"
    assert @internal.valid?, @internal.errors.full_messages

    @internal.summattava_taso = "#{@internal2.taso},   #{@internal3.taso}"
    assert @internal.valid?, @internal.errors.full_messages

    #with wrong sti type
    @internal.summattava_taso = @external2.taso
    refute @internal.valid?, @internal.errors.full_messages
  end

  test "kumulatiivinen should be empty string or X" do
    values = {
      "not_cumulative" => "",
      "cumulative"     => "X"
    }
    assert_equal values, @internal.class.kumulatiivinens
  end

  test "kayttotarkoitus should be empty or M or O" do
    values = {
      "normal"    => "",
      "turnover"  => "M",
      "purchases" => "O"
    }
    assert_equal values, @internal.class.kayttotarkoitus
  end

  test "initializing new SumLevel with tyyppi sets class correctly" do
    {
      S: "SumLevel::Internal",
      U: "SumLevel::External",
      A: "SumLevel::Vat",
      B: "SumLevel::Profit",
      E: "SumLevel::Commodity"
    }.each do |tyyppi, class_name|
      sum_level = SumLevel.new(tyyppi: tyyppi.to_s)

      assert_equal class_name, sum_level.class.to_s
    end
  end

  test "default_child_instance returns correct class" do
    assert_equal SumLevel::Internal, SumLevel.default_child_instance
  end

  test "subclass_from_attributes returns nil if subclass can't be found with the provided tyyppi" do
    assert_nil SumLevel.subclass_from_attributes({ tyyppi: "M" })
  end

  test "SumLevel::Commodity should have multiple accounts" do
    assert_equal 1, @commodity.accounts.count
    assert_not_nil @commodity.poistovasta_account.tilino
    assert_not_nil @commodity.poistoero_account.tilino
    assert_not_nil @commodity.poistoerovasta_account.tilino
  end
end
