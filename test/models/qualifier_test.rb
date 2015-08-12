require 'test_helper'

class QualifierTest < ActiveSupport::TestCase
  def setup
    @project_with_account = qualifiers(:project_in_use)
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

  test "if someone tries to deactivate qualifier check account assosiation" do
    @project_with_account.kaytossa = :not_in_use
    refute @project_with_account.valid?

    @project_with_account.kaytossa = :in_use
    assert @project_with_account.valid?
  end

  test "human_readable_type works" do
    assert_equal "Kustannuspaikka", Qualifier::CostCenter.human_readable_type
    assert_equal "Projekti", Qualifier::Project.human_readable_type
    assert_equal "Kohde", Qualifier::Target.human_readable_type
  end

  test "model_name works" do
    assert_equal Qualifier.model_name, Qualifier::CostCenter.model_name
    assert_equal Qualifier.model_name, Qualifier::Project.model_name
    assert_equal Qualifier.model_name, Qualifier::Target.model_name
  end

  test "default_child_instance works" do
    assert_equal Qualifier::Project, Qualifier.default_child_instance
  end
end
