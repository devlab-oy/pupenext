require 'test_helper'

class QualifierTest < ActiveSupport::TestCase
  fixtures %w(qualifiers accounts)

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

  test "should return kaytossa char" do
    assert_equal 'o', Qualifier.in_use_char
    assert_equal 'E', Qualifier.not_in_use_char
  end

  test "kaytossa_options should be 2" do
    assert_equal 2, Qualifier.kaytossa_options.count
  end

  test "should deactivate project" do
    project_without_account = qualifiers(:project_in_use_without_account)
    assert_equal "project_in_use_without_account", project_without_account.nimi
    project_without_account.deactivate!

    assert project_without_account.valid?, project_without_account.errors.full_messages
    assert_equal Qualifier.not_in_use_char, project_without_account.kaytossa
  end

  test "should activate project" do
    project_not_in_use = Qualifier::Project.not_in_use.where(koodi: '12345').first
    project_not_in_use.activate!
    assert_equal Qualifier.in_use_char, project_not_in_use.kaytossa
  end

  test "if someone tries to deactivate qualifier check account assosiation" do
    @project_with_account.deactivate!
    refute @project_with_account.valid?

    @project_with_account.activate!
    assert @project_with_account.valid?, @project_with_account.errors.full_messages
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
