require 'test_helper'

class Administration::IncomingMailsControllerTest < ActionController::TestCase
  fixtures %w(
    incoming_mails
    mail_servers
  )

  setup do
    login users(:bob)
  end

  test 'index works' do
    get :index

    assert_response :success

    assert_select 'h1', I18n.t('administration.incoming_mails.index.header')

    IncomingMail.all.each_with_index do |incoming_mail, index|
      row = css_select('#incoming_mails tbody tr')[index]

      processed_at = incoming_mail.processed_at ? I18n.l(incoming_mail.processed_at) : ''

      assert_equal incoming_mail.mail_server.to_s,    css_select(row, 'td')[0].content
      assert_equal processed_at,                      css_select(row, 'td')[1].content
      assert_equal incoming_mail.status.to_s,         css_select(row, 'td')[2].content
      assert_equal incoming_mail.status_message.to_s, css_select(row, 'td')[3].content
    end
  end
end
