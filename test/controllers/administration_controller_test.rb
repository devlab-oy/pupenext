require 'test_helper'

# The purpose of AdministrationControllerTest is to test the common logic behind AdministrationController
class AdministrationControllerTest < ActionController::TestCase
  tests Administration::SumLevelsController

  fixtures %w(sum_levels keywords)

  setup do
    login users(:joe)
    @sum_level = sum_levels(:external)
  end

  test "should not get resources index" do
    login users(:max)

    get :index
    assert_response :forbidden
  end

  test "should not get resources new" do
    get :new
    assert_response :forbidden
  end

  test "should show resource with read access" do
    request = { id: @sum_level.id }
    get :show, request
    assert_response :success
  end

  test "should not show resource" do
    login users(:max)

    request = { id: @sum_level.id }
    get :show, request
    assert_response :forbidden
  end

  test "should not create resource with no access" do
    assert_no_difference('SumLevel.count') do
      #With valid request
      request = {
        tyyppi: 'U',
        summattava_taso: '',
        taso: '29',
        nimi: 'TILIKAUDEN TULOS2221',
        oletusarvo: '',
        jakaja: '',
        kumulatiivinen: '',
        kayttotarkoitus: '',
        kerroin: '',
      }
      post :create, sum_level: request
    end

    assert_response :forbidden
  end


  test "should not get resources edit" do
    login users(:max)

    request = { id: @sum_level.id }
    get :edit, request
    assert_response :forbidden
  end

  test "should get resources edit without update access" do
    request = { id: @sum_level.id }
    get :edit, request
    assert_response :success
  end

  test "should not update resource" do
    patch :update, id: @sum_level.id, sum_level: { nimi: 'Uusi nimi' }
    assert_response :forbidden
  end

  test "should not destroy resource" do
    assert_no_difference('SumLevel.count') do
      delete :destroy, id: @sum_level.id
    end

    assert_response :forbidden
  end

  test 'resource parameters' do
    attribute_one = keywords :mysql_alias_1
    attribute_two = keywords :mysql_alias_2

    # We need to set params hash, because we don't have a request
    @controller.params = { sum_level: { foo: '', bar: '', nimi: '', taso: '' } }

    # We set two visible custom attributes to the Default -set
    attribute_one.update! database_field: 'taso.nimi', set_name: 'Default', visibility: :visible
    attribute_two.update! database_field: 'taso.taso', set_name: 'Default', visibility: :visible

    # We should get both back alphabetically, overriding passed parameters
    params = @controller.resource_parameters(model: :sum_level, parameters: [:foo, :bar])
    assert_equal ['nimi', 'taso'], params.keys

    # Make one of them hidden, we should get only one
    attribute_one.update! visibility: :hidden, default_value: ''
    params = @controller.resource_parameters(model: :sum_level, parameters: [:foo, :bar])
    assert_equal ['taso'], params.keys

    # Make both hidden, we should get an empty array
    attribute_two.update! visibility: :hidden
    params = @controller.resource_parameters(model: :sum_level, parameters: [:foo, :bar])
    assert_equal [], params.keys

    # If we don't have any keywords in the default set, we'll get back the passed params
    attribute_one.update! set_name: 'another_set'
    attribute_two.update! set_name: 'another_set'
    params = @controller.resource_parameters(model: :sum_level, parameters: [:foo, :bar])
    assert_equal ['foo', 'bar'], params.keys
  end

  test 'should allow default params' do
    login users(:bob)

    patch :update, id: @sum_level.id, commit: "yes", sum_level: { nimi: 'the_new_name!' }
    assert_equal 'the_new_name!', @sum_level.reload.nimi
  end

  test 'should deny hidden params set in default custom attributes' do
    login users(:bob)
    attribute = keywords(:mysql_alias_1)

    attribute.update! database_field: 'taso.nimi', set_name: 'Default', visibility: :hidden

    patch :update, id: @sum_level.id, commit: "yes", sum_level: { nimi: 'the_new_name!' }
    refute_equal 'the_new_name!', @sum_level.reload.nimi
  end

  test 'should allow hidden params set in default custom attributes' do
    login users(:bob)
    attribute = keywords(:mysql_alias_1)

    attribute.update! database_field: 'taso.nimi', set_name: 'Default', visibility: :visible

    patch :update, id: @sum_level.id, commit: "yes", sum_level: { nimi: 'the_new_name!' }
    assert_equal 'the_new_name!', @sum_level.reload.nimi
  end

  test 'should allow visible params for given attribute set' do
    login users(:bob)

    attribute = keywords(:mysql_alias_1)
    permission = permissions(:bob_sum_levels_update)

    attribute.update! database_field: 'taso.nimi', set_name: 'bobset', visibility: :visible
    permission.update! alias_set: 'bobset'

    patch :update, id: @sum_level.id, commit: "yes", sum_level: { nimi: 'the_new_name!' }
    refute_equal 'the_new_name!', @sum_level.reload.nimi

    patch :update, id: @sum_level.id, commit: "yes", sum_level: { nimi: 'the_new_name!' }, alias_set: :bobset
    assert_equal 'the_new_name!', @sum_level.reload.nimi
  end

  test 'should deny hidden params for given attribute set' do
    login users(:bob)

    attribute = keywords(:mysql_alias_1)
    permission = permissions(:bob_sum_levels_update)

    attribute.update! database_field: 'taso.nimi', set_name: 'bobset', visibility: :hidden
    permission.update! alias_set: 'bobset'

    patch :update, id: @sum_level.id, commit: "yes", sum_level: { nimi: 'the_new_name!' }
    refute_equal 'the_new_name!', @sum_level.reload.nimi

    patch :update, id: @sum_level.id, commit: "yes", sum_level: { nimi: 'the_new_name!' }, alias_set: :bobset
    refute_equal 'the_new_name!', @sum_level.reload.nimi
  end

  test 'should set default value on create even if attributes are hidden' do
    login users(:bob)

    # Let's duplicate attributes so we can add all required fields
    attribute1 = keywords(:mysql_alias_1)
    attribute2 = attribute1.dup
    attribute3 = attribute1.dup
    attribute1.update! database_field: 'taso.taso', set_name: 'Default', visibility: :hidden, default_value: '112233'
    attribute2.update! database_field: 'taso.nimi', set_name: 'Default', visibility: :hidden, default_value: 'foobar'
    attribute3.update! database_field: 'taso.tyyppi', set_name: 'Default', visibility: :visible

    # We submit only tyyppi, we have default values for other required fields in hidden columns
    request = {
      sum_level: {
        tyyppi: 'U'
      },
      commit: "joo"
    }

    assert_difference 'SumLevel.count' do
      post :create, request
    end

    assert_redirected_to sum_levels_path
    assert_equal '112233', assigns(:sum_level).taso
    assert_equal 'foobar', assigns(:sum_level).nimi
  end

  test 'default value should not override if attributes are visible' do
    login users(:bob)

    # Let's duplicate attributes so we can add all required fields
    attribute1 = keywords(:mysql_alias_1)
    attribute2 = attribute1.dup
    attribute3 = attribute1.dup
    attribute1.update! database_field: 'taso.taso', set_name: 'Default', visibility: :visible, default_value: '112233'
    attribute2.update! database_field: 'taso.nimi', set_name: 'Default', visibility: :visible, default_value: 'foobar'
    attribute3.update! database_field: 'taso.tyyppi', set_name: 'Default', visibility: :visible

    request = {
      sum_level: {
        tyyppi: 'U',
        taso: '223344',
        nimi: 'barbaz'
      },
      commit: "joo"
    }

    assert_difference 'SumLevel.count' do
      post :create, request
    end

    assert_redirected_to sum_levels_path
    assert_equal '223344', assigns(:sum_level).taso
    assert_equal 'barbaz', assigns(:sum_level).nimi
  end

  test 'updating existing record should not use default values' do
    login users(:bob)

    # Let's duplicate attributes so we can add all required fields
    attribute1 = keywords(:mysql_alias_1)
    attribute2 = attribute1.dup
    attribute3 = attribute1.dup
    attribute1.update! database_field: 'taso.taso', set_name: 'Default', visibility: :visible, default_value: '112233'
    attribute2.update! database_field: 'taso.nimi', set_name: 'Default', visibility: :hidden, default_value: 'foobar'
    attribute3.update! database_field: 'taso.tyyppi', set_name: 'Default', visibility: :visible
    @sum_level.update! nimi: 'notfoobar'

    # We submit tyyppi and taso. nimi is hidden, but has a default value.
    request = {
      id: @sum_level.id,
      commit: "joo",
      sum_level: {
        tyyppi: 'U',
        taso: '332211'
      }
    }

    patch :update, request
    assert_redirected_to sum_levels_path
    assert_equal '332211', assigns(:sum_level).reload.taso
    assert_equal 'notfoobar', assigns(:sum_level).nimi
  end
end
