require 'test_helper'

class Administration::PrintersControllerTest < ActionController::TestCase

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

    assert_template 'new', 'Template should be new'
  end

  test 'should create new printer' do
    assert_difference('Printer.count', 1) do
      post :create, printer: { merkisto: 1, mediatyyppi: "A4", komento: "lpr -P testitulostin",
                               kirjoitin: "Testitulostin" }
    end

    assert_redirected_to printers_path
  end

  test 'should not create new printer' do
    assert_no_difference('Printer.count') do
      post :create, printer: { kirjoitin: "" }
      assert_template 'new', 'Template should be new'
    end
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
end
