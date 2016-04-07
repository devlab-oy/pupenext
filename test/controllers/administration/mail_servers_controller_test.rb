require 'test_helper'

class Administration::MailServersControllerTest < ActionController::TestCase
  setup do
    login users(:bob)
  end

  test 'GET index' do
    get :index

    assert_response :success

    assert_select 'h1', I18n.t('administration.mail_servers.index.header')

    headers = css_select('table#mail_servers > thead > tr > th')

    assert_equal headers[0].content, MailServer.human_attribute_name(:imap_server)
    assert_equal headers[1].content, MailServer.human_attribute_name(:smtp_server)
    assert_equal headers[2].content, MailServer.human_attribute_name(:processing_type)
  end
end
