require 'test_helper'

class PackingAreaTest < ActiveSupport::TestCase
  setup do
    @q = packing_areas(:first)
  end

  test "assert fixtures are valid" do
    assert packing_areas(:first).valid?
    assert packing_areas(:second).valid?
  end

  test "name cant be empty" do
    @q.nimi = ''
    refute @q.valid?
  end

  test "lokero cant be empty" do
    @q.lokero = ''
    refute @q.valid?
  end

  test "prio cant be empty" do
    @q.prio = ''
    refute @q.valid?
  end

  test "pakkaamon prio cant be empty" do
    @q.pakkaamon_prio = ''
    refute @q.valid?
  end

  test "varasto cant be empty" do
    @q.varasto = ''
    refute @q.valid?
  end

  test "printteri0 cant be empty" do
    @q.printteri0 = ''
    refute @q.valid?
  end

  test "printteri1 cant be empty" do
    @q.printteri1 = ''
    refute @q.valid?
  end

  test "printteri2 cant be empty" do
    @q.printteri2 = ''
    refute @q.valid?
  end

  test "printteri3 cant be empty" do
    @q.printteri3 = ''
    refute @q.valid?
  end

  test "printteri4 cant be empty" do
    @q.printteri4 = ''
    refute @q.valid?
  end

  test "printteri6 cant be empty" do
    @q.printteri6 = ''
    refute @q.valid?
  end

  test "printteri7 cant be empty" do
    @q.printteri7 = ''
    refute @q.valid?
  end

  test "should get duplicate cell" do
    @q.lokero = "4-5"
    refute @q.valid?, @q.errors.full_messages
  end
end
