require 'test_helper'

class Administration::PackingAreasControllerTest < ActionController::TestCase
  fixtures %w(packing_areas warehouses)

  setup do
    login users(:joe)
    @packing_area = packing_areas(:first)
  end

  test "should be valid" do
    assert @packing_area.valid?
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show, id: @packing_area.id
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @packing_area.id
    assert_response :success
  end

  test "should get new" do
    login users(:bob)
    get :new
    assert_response :success
  end

  test "should create" do
    login users(:bob)

    request = {
      nimi: 'Kissa',
      lokero: '10',
      prio: 5,
      pakkaamon_prio: 3,
      varasto: 3,
      printteri0: 22,
      printteri1: 22,
      printteri2: 22,
      printteri3: 22,
      printteri4: 22,
      printteri6: 22,
      printteri7: 22
    }

    assert_difference('PackingArea.count', 1) do
      post :create, packing_area: request
    end

    assert_redirected_to packing_areas_path, response.body
  end

  test "should not create" do
    login users(:bob)

    request = {
      nimi: 'Kissa',
      lokero: '10',
      prio: 5,
      pakkaamon_prio: 3,
      varasto: 3,
      printteri0: 22,
      printteri1: nil,
      printteri2: 22,
      printteri3: 22,
      printteri4: 22,
      printteri6: 22,
      printteri7: 22
    }

    assert_no_difference('PackingArea.count') do
      post :create, packing_area: request
    end

    assert_template "edit", "Template should be edit"
  end

  test "should update" do
    login users(:bob)

    request = {
      nimi: 'Koira',
      lokero: '4-4'
    }

    patch :update, id: @packing_area.id, packing_area: request
    assert_redirected_to packing_areas_path
  end

  test "should not update" do
    login users(:bob)

    patch :update, id: @packing_area.id, packing_area: { nimi: '' }
    assert_template "edit", "Template should be edit"
  end

  test "should destroy" do
    login users(:bob)

    assert_difference('PackingArea.count', -1) do
      post :destroy, id: @packing_area.id
    end
  end
end
