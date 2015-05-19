require 'test_helper'

class FreightContractTest < ActiveSupport::TestCase
  setup do
    @one = freight_contracts(:freight_contract_1)
    @two = freight_contracts(:freight_contract_2)
  end

  test "fixtures are valid" do
    assert @one.valid?, @one.errors.full_messages
    assert @two.valid?, @two.errors.full_messages
  end

  test "ordered scope works" do
    assert_equal 351, FreightContract.ordered.count
  end

  test "delivery method saved to freight contract must exist" do
    customer = customers(:stubborn_customer)

    freight_contract = FreightContract.new(toimitustapa: "Kissa",
                                           asiakas: customer.tunnus,
                                           ytunnus: customer.ytunnus,
                                           rahtisopimus: "13579",
                                           selite: "kala",
                                           muumaksaja: "Muumipeikko"
    )

    refute freight_contract.valid?
  end
end
