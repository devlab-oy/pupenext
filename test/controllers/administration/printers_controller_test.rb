require 'test_helper'

class Administration::PrintersControllerTest < ActionController::TestCase

  def setup
    cookies[:pupesoft_session] = users(:joe).session
  end

  test 'should get all printers' do
    request = {format: :html}

    get :index, request
    assert_response :success

    assert_template "index", "Template should be index"
  end

  test 'should show printer' do
    request = {format: :html, id: 1}

    get :show, request
    assert_response :success

    assert_template "edit", "Template should be edit"
  end

  test 'should show new printer form' do
    get :new
    assert_response :success

    assert_template 'new', 'Template should be new'
  end

  test 'should create new printer' do
    assert_difference('Printer.count') do
      post :create, printer: {nimi: 'TES', kurssi: 0.8}
    end

    assert_redirected_to printers_path
    assert_equal 'Printer was successfully created.', flash[:notice]
  end

  test 'should not create new printer' do
    assert_no_difference('Printer.count') do
      post :create, printer: {}
      assert_template 'new', 'Template should be new'
    end
  end

  test 'should update printer' do
    patch :update, id: 1, printer: {nimi: 'TES'}

    assert_redirected_to printers_path
    assert_equal 'Printer was successfully updated.', flash[:notice]
  end

  test 'should not update printer' do
    patch :update, id: 1, printer: {nimi: ''}

    assert_template 'edit', 'Template should be edit'
  end
end
