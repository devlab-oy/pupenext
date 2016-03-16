class Transport < ActiveRecord::Base
  belongs_to :transportable, polymorphic: true

  validates :encoding, inclusion: { in: Encoding.list.map(&:to_s) }, allow_blank: true
  validates :hostname, presence: true
  validates :password, presence: true
  validates :path, presence: true
  validates :port, numericality: { only_integer: true }, allow_blank: true
  validates :transportable, presence: true
  validates :username, presence: true
end
