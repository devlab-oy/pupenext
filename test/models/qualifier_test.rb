require 'test_helper'

class QualifierTest < ActiveSupport::TestCase
  fixtures %w(qualifiers accounts)

  def setup
    @project_with_account = qualifiers(:project_in_use)
  end

  test "all fixtures are valid" do
    assert qualifiers(:project_in_use).valid?
    assert qualifiers(:target_in_use).valid?
    assert qualifiers(:cost_center_in_use).valid?
    assert qualifiers(:project_not_in_use).valid?
    assert qualifiers(:project_in_use_without_account).valid?
  end

  test "nimi should be present" do
    @project_with_account.nimi = ''
    refute @project_with_account.valid?

    @project_with_account.nimi = nil
    refute @project_with_account.valid?

    @project_with_account.nimi = 'Nimi'
    assert @project_with_account.valid?

    @project_with_account.nimi = 1
    assert @project_with_account.valid?

    @project_with_account.nimi = 0
    assert @project_with_account.valid?
  end

  test "should return nimitys" do
    assert_equal "123 Projektin nimi", @project_with_account.nimitys
  end

  test "kaytossa should have 2 values" do
    values = { "not_in_use" => "E", "in_use" => "o" }
    assert_equal values, Qualifier.kaytossas
  end

  test 'cannot deactivate if in use' do
    # Make sure we have no relations
    Account.update_all kustp: 0
    account = accounts :account_100
    kustp = qualifiers :cost_center_in_use

    # We should be able to disable qualifier
    kustp.kaytossa = :not_in_use
    assert kustp.valid?

    # ... and enable
    kustp.kaytossa = :in_use
    assert kustp.valid?

    # Use qualifier on account
    account.update_attribute :kustp, kustp.id

    # We should not be able to disable qualifier
    kustp.kaytossa = :not_in_use
    refute kustp.valid?
  end

  test "models have human names" do
    assert_equal "Kustannuspaikka", Qualifier::CostCenter.model_name.human
    assert_equal "Projekti", Qualifier::Project.model_name.human
    assert_equal "Kohde", Qualifier::Target.model_name.human
  end

  test "default_child_instance works" do
    assert_equal Qualifier::Project, Qualifier.default_child_instance
  end

  test "creates correct model based on tyyppi" do
    klass = Qualifier.new tyyppi: 'P'
    assert_equal Qualifier::Project, klass.class

    klass = Qualifier.new tyyppi: 'O'
    assert_equal Qualifier::Target, klass.class

    klass = Qualifier.new tyyppi: 'K'
    assert_equal Qualifier::CostCenter, klass.class

    @project_with_account.tyyppi = 'not_valid'
    refute @project_with_account.valid?

    Qualifier.child_class_names.each do |q|
      @project_with_account.tyyppi = q.first
      assert @project_with_account.valid?
    end
  end
end
