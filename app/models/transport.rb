class Transport < ActiveRecord::Base
  belongs_to :transportable, polymorphic: true

  validates :customer, presence: true
  validates :hostname, presence: true
  validates :password, presence: true
  validates :username, presence: true
  validates :path, presence: true
end
