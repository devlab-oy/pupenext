class IncomingMail < ActiveRecord::Base
  enum status: [:ok, :error]

  belongs_to :mail_server, required: true
  has_one    :company, through: :mail_server, required: true

  validates :raw_source, presence: true
end
