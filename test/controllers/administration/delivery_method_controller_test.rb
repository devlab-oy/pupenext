require 'test_helper'

class Administration::DeliveryMethodsControllerTest < ActionController::TestCase
  fixtures %w(
    delivery_methods
    packages
  )

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
        rahtikirja: 'generic_a4',
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

    deli2 = delivery_methods :kiitolinja

    assert_difference("DeliveryMethod.count", -1) do
      delete :destroy, id: deli2.id
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

  test "should add translations" do
    login users(:bob)

    params = {
      translations_attributes: {
        "0" => {
          kieli: 'no',
          selitetark: 'Kaukokiito Transports',
        }
      }
    }

    assert_difference 'Keyword::DeliveryMethodTranslation.count' do
      patch :update, id: @delivery_method.id, delivery_method: params
    end
  end

  test "should update and destroy translations" do
    login users(:bob)
    translated = keywords :deliverymethod_locale_en

    params = {
      translations_attributes: {
        "0" => {
          id: translated.id,
          selitetark: 'a translation',
        }
      }
    }

    assert_no_difference('Keyword::DeliveryMethodTranslation.count') do
      patch :update, id: translated.delivery_method.id, delivery_method: params
    end

    assert_equal 'a translation', translated.reload.selitetark

    params = {
      translations_attributes: {
        "0" => {
          id: translated.id,
          _destroy: 'true',
        }
      }
    }

    assert_difference('Keyword::DeliveryMethodTranslation.count', -1) do
      patch :update, id: translated.delivery_method.id, delivery_method: params
    end
  end
end
