class MailServer < ActiveRecord::Base
  belongs_to :company, required: true

  validates :imap_server,     presence: true
  validates :imap_username,   presence: true
  validates :imap_password,   presence: true
  validates :process_dir,     presence: true
  validates :done_dir,        presence: true
  validates :processing_type, presence: true, inclusion: { in: %w(huutokauppa) }

  with_options if: 'smtp_server.present?' do |o|
    o.validates :smtp_username, presence: true
    o.validates :smtp_password, presence: true
  end
end
