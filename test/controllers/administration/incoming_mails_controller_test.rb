require 'test_helper'

class Administration::IncomingMailsControllerTest < ActionController::TestCase
  setup do
    login users(:bob)
  end

  test 'index works' do
    get :index

    assert_response :success

    assert_select 'h1', I18n.t('administration.incoming_mails.index.header')
  end
end
