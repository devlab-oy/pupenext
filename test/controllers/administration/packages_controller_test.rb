require 'test_helper'

class Administration::PackagesControllerTest < ActionController::TestCase
  fixtures %w(packages keywords package_codes)

  setup do
    login users(:bob)
    @package = packages(:steel_barrel)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show, id: @package.id
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create" do
    request = {
      pakkaus: 'Kissa',
      pakkauskuvaus: '10',
      leveys: 10,
      korkeus: 10,
      syvyys: 10,
      paino: 10
    }

    assert_difference('Package.count', 1) do
      post :create, package: request
    end

    assert_redirected_to packages_path, response.body
  end

  test "should not create" do
    request = {
      pakkaus: 'Kissa',
      kayttoprosentti: 0
    }

    assert_no_difference('Package.count') do
      post :create, package: request
    end
  end

  test "should get edit" do
    get :edit, id: @package.id
    assert_response :success
  end

  test "should update" do
    request = {
      pakkaus: 'Kissa',
      pakkauskuvaus: 'xxx',
      leveys: 10,
      korkeus: 10,
      syvyys: 10,
      paino: 10
    }

    patch :update, id: @package.id, package: request
    assert_redirected_to packages_path
  end

  test "should not update" do
    request = {
      pakkaus: 'Kissa',
      pakkauskuvaus: nil
    }

    patch :update, id: @package.id, package: request
    assert_template :edit, "Template should be edit"
  end

  test "should add translations" do
    params = {
      translations_attributes: {
        "0" => {
          kieli: 'no',
          selitetark: 'stål fat',
        }
      }
    }

    assert_difference('Keyword::PackageTranslation.count') do
      patch :update, id: @package.id, package: params
    end
  end

  test "should update and destroy translations" do
    translated = keywords(:package_locale_en)

    params = {
      translations_attributes: {
        "0" => {
          id: translated.id,
          selitetark: 'a translation',
        }
      }
    }

    assert_no_difference('Keyword::PackageTranslation.count') do
      patch :update, id: translated.package.id, package: params
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

    assert_difference('Keyword::PackageTranslation.count', -1) do
      patch :update, id: translated.package.id, package: params
    end
  end

  test "should add package code" do
    params = {
      package_codes_attributes: {
        "0" => {
          pakkaus: 'foo',
          rahdinkuljettaja: 'bar',
          koodi: 'baz'
        }
      }
    }

    assert_difference('PackageCode.count') do
      patch :update, id: @package.id, package: params
    end
  end

  test "should update and destroy package codes" do
    code = package_codes(:code_aa)

    params = {
      package_codes_attributes: {
        "0" => {
          id: code.id,
          koodi: 'a new code',
        }
      }
    }

    assert_no_difference('PackageCode.count') do
      patch :update, id: code.package.id, package: params
    end

    assert_equal 'a new code', code.reload.koodi

    params = {
      package_codes_attributes: {
        "0" => {
          id: code.id,
          _destroy: 'true',
        }
      }
    }

    assert_difference('PackageCode.count', -1) do
      patch :update, id: code.package.id, package: params
    end
  end

  test 'DELETE destroy' do
    delete :destroy, id: @package.id

    assert_redirected_to packages_url
  end
end
