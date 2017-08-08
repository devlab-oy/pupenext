require 'test_helper'

class InvoiceEmailJobTest < ActiveJob::TestCase
  fixtures %w(
    incoming_mails
    mail_servers
  )

  setup do
    @mail = incoming_mails :two

    # vaihdetaan puperoot ja skannaus polku tyhjäksi, jotta saadaan kuva tallentumaan temppiin
    Rails.application.secrets.pupesoft_install_dir = '/tmp'
    @mail.company.parameter.update! skannatut_laskut_polku: ''

    # sallitus domainit
    Rails.application.secrets.invoice_mail_allowed_domains = 'devlab.fi'

    # asetetaan source ja käsittelemättömäksi
    @mail.update!(
      raw_source: File.read(Rails.root.join('test', 'assets', 'invoice_emails', 'one_image')),
      status: nil,
      status_message: nil,
    )
  end

  test 'job is enqueued correctly' do
    assert_enqueued_jobs 0

    assert_enqueued_with(job: InvoiceEmailJob, queue: 'invoice_email') do
      InvoiceEmailJob.perform_later(id: @mail.id)
    end

    assert_enqueued_jobs 1
  end

  test 'status is ok and file is saved' do
    InvoiceEmailJob.perform_now(id: @mail.id)

    assert_equal 'ok', @mail.reload.status
    assert_equal 'Liitetiedosto käsitelty: Photo.jpg', @mail.status_message
  end

  test 'allowed domains' do
    # sallitus domainit
    Rails.application.secrets.invoice_mail_allowed_domains = 'devlab.com'

    InvoiceEmailJob.perform_now(id: @mail.id)

    assert_equal 'error', @mail.reload.status
    assert_equal 'Lähettäjän domain ei ole sallittu: joni@devlab.fi', @mail.status_message
  end

  test 'no images' do
    # asetetaan source jossa ei ole kuvaa
    @mail.update!(
      raw_source: File.read(Rails.root.join('test', 'assets', 'invoice_emails', 'no_image')),
    )

    InvoiceEmailJob.perform_now(id: @mail.id)

    assert_equal 'error', @mail.reload.status
    assert_equal 'Viestissä ei ollut liitetiedostoja', @mail.status_message
  end
end
