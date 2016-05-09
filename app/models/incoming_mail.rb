class IncomingMail < ActiveRecord::Base
  include Searchable

  belongs_to :mail_server, required: true
  has_one    :company, through: :mail_server, required: true

  enum status: [:ok, :error]

  validates :raw_source, presence: true

  delegate :subject, to: :mail, allow_nil: true

  def mail
    @mail ||= Mail.new(raw_source)
  end
end
