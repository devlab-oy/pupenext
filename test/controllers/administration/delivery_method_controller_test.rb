require 'test_helper'

class Administration::DeliveryMethodsControllerTest < ActionController::TestCase
  fixtures %w(delivery_methods packages)

  def setup
    login users(:joe)
    @delivery_method = delivery_methods(:kaukokiito)
  end

  test 'should get index' do
    get :index
    assert_response :success

    assert_template "index", "Template should be index"
  end

  test 'should get edit' do
    get :edit, id: @delivery_method.tunnus
    assert_response :success
  end

  test 'show should be edit' do
    get :show, id: @delivery_method.tunnus
    assert_response :success
  end

  test 'should create delivery method' do
    login users(:bob)

    assert_difference('DeliveryMethod.count', 1, response.body) do

      params = {
        selite: "Random delivery method",
        tulostustapa: 'H',
        sopimusnro: '',
        nouto: :shipment,
        ei_pakkaamoa: '1',
        extranet: :only_in_sales,
        rahtikirja: 'rahtikirja.inc',
        jarjestys: 1
      }

      post :create, delivery_method: params
      assert_redirected_to delivery_methods_path
    end
  end

  test 'should not create delivery method' do
    login users(:bob)

    assert_no_difference('DeliveryMethod.count') do

      params = {
        not_existing_column: true,
        nouto: ''
      }

      post :create, delivery_method: params
      assert_template "edit", "Template should be edit"
    end
  end

  test 'should update delivery method' do
    login users(:bob)

    params = { tulostustapa: :collective_batch }

    patch :update, id: @delivery_method.id, delivery_method: params
    assert_redirected_to delivery_methods_path
  end

  test 'should not update delivery method' do
    login users(:bob)

    params = { selite: 'Kiitolinja' }

    patch :update, id: @delivery_method.id, delivery_method: params
    assert_template "edit", "Template should be edit"
  end

  test "should delete delivery method" do
    login users(:bob)

    @delivery_method.selite = 'Random delivery method'
    @delivery_method.save

    assert_difference("DeliveryMethod.count", -1) do
      delete :destroy, id: @delivery_method.id
    end

    assert_redirected_to delivery_methods_path
  end

  test 'should save sallitut_alustat array as string' do
    login users(:bob)
    package_one = packages(:steel_barrel).id
    package_two = packages(:oak_barrel).id

    params = { sallitut_alustat: [ package_one, package_two, '' ] }

    patch :update, id: @delivery_method.id, delivery_method: params
    assert_redirected_to delivery_methods_path

    assert_equal "#{package_one},#{package_two}", @delivery_method.reload.sallitut_alustat
  end
end
