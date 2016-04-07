require 'test_helper'

class Administration::MailServersControllerTest < ActionController::TestCase
  fixtures %w(
    mail_servers
  )

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

    rows = css_select('table#mail_servers > tbody > tr')

    MailServer.all.each_with_index do |mail_server, index|
      row = rows[index]

      assert_equal mail_server.imap_server,     css_select(row, 'td')[0].content
      assert_equal mail_server.smtp_server,     css_select(row, 'td')[1].content
      assert_equal mail_server.processing_type, css_select(row, 'td')[2].content
    end
  end

  test 'GET new' do
    get :new

    assert_response :success

    assert_select 'h1', I18n.t('administration.mail_servers.new.header')

    assert_select 'form#new_mail_server'
  end

  test 'GET edit' do
    get :edit, id: mail_servers(:one).id

    assert_response :success

    assert_select 'h1', I18n.t('administration.mail_servers.edit.header')

    assert_select "form#edit_mail_server_#{mail_servers(:one).id}"
  end

  test 'POST create' do
    params = {
      mail_server: {
        imap_server:     'imap3.example.com',
        imap_username:   'test_user_3',
        imap_password:   'secret',
        smtp_server:     'smtp3.example.com',
        smtp_username:   'test_user_3',
        smtp_password:   'secret',
        process_dir:     'processing',
        done_dir:        'ready',
        processing_type: 'huutokauppa'
      }
    }

    assert_difference 'MailServer.count' do
      post :create, params

      assert_redirected_to mail_servers_url
    end
  end

  test 'POST create with invalid params' do
    params = {
      mail_server: {
        imap_username:   'test_user_3',
        imap_password:   'secret',
        smtp_server:     'smtp3.example.com',
        smtp_username:   'test_user_3',
        smtp_password:   'secret',
        process_dir:     'processing',
        done_dir:        'ready',
        processing_type: 'huutokauppa'
      }
    }

    assert_no_difference 'MailServer.count' do
      post :create, params

      assert_select '#error_explanation'
    end
  end

  test 'PATCH update' do
    patch :update, id: mail_servers(:one).id

    assert_redirected_to mail_servers_url
  end
end
