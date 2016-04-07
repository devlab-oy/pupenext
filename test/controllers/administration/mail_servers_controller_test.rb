require 'test_helper'

class Administration::MailServersControllerTest < ActionController::TestCase
  setup do
    login users(:bob)
  end

  test 'GET index' do
    get :index

    assert_response :success

    assert_select 'h1', I18n.t('administration.mail_servers.index.header')
  end
end
