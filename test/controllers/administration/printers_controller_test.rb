require 'test_helper'

class Administration::PrintersControllerTest < ActionController::TestCase
  fixtures %w(printers)

  def setup
    login users(:bob)
    @printer1 = printers(:printer1)
  end

  test 'should get all printers' do
    get :index
    assert_response :success

    assert_template "index", "Template should be index"
  end

  test 'should show printer' do
    get :show, id: @printer1.id
    assert_response :success

    assert_template "edit", "Template should be edit"
  end

  test 'should show new printer form' do
    get :new
    assert_response :success

    assert_template 'edit', 'Template should be edit'
  end

  test 'should create new printer' do
    params = { merkisto: 'charset_7bit', mediatyyppi: "media_a4", nimi: "Testinimi",
               kirjoitin: "Testitulostin", unifaun_nimi: "kala", osoite: "Testitie 6",
               postino: "00100", postitp: "Turku", puhelin: "555 111 222",
               yhteyshenkilo: "Testiukko", jarjestys: 1, komento: "lpr -P testitulostin" }

    assert_difference('Printer.count', 1) do
      post :create, printer: params
    end

    params.each do |attribute_key, attribute_value|
      assert_equal attribute_value, Printer.last.send(attribute_key),
                   "Attribute #{attribute_key} did not get set"
    end

    assert_redirected_to printers_path
  end

  test 'does not create a new printer with invalid parameters' do
    assert_no_difference('Printer.count') do
      post :create, printer: { kirjoitin: "" }
      assert_template 'edit', 'Template should be edit'
    end
  end

  test "does not allow creating a new printer with invalid privileges" do
    login users(:joe)

    assert_no_difference("Printer.count") do
      post :create, printer: { kirjoitin: "testing", komento: "kala" }
    end

    assert_response :forbidden
  end

  test 'should update printer' do
    patch :update, id: @printer1.id, printer: { kirjoitin: 'Testikirjoitin 2' }
    assert_equal @printer1.reload.kirjoitin, "Testikirjoitin 2"

    assert_redirected_to printers_path
  end

  test 'should not update printer' do
    patch :update, id: @printer1.id, printer: { kirjoitin: '' }

    assert_template 'edit', 'Template should be edit'
  end

  test "deleting printer works" do
    assert_difference("Printer.count", -1) do
      delete :destroy, id: @printer1.id
    end

    assert_redirected_to printers_path
  end
end
