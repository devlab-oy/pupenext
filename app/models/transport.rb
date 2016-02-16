class Transport < ActiveRecord::Base
  belongs_to :transportable, polymorphic: true

  validates :transportable, presence: true
  validates :hostname, presence: true
  validates :password, presence: true
  validates :username, presence: true
  validates :path, presence: true
  validates :port, numericality: { only_integer: true }, allow_blank: true
end
