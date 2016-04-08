class IncomingMail < ActiveRecord::Base
  belongs_to :mail_server, required: true
  has_one    :company, through: :mail_server, required: true

  enum status: [:ok, :error]

  validates :raw_source, presence: true
end
