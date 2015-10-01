class Download::Download < ActiveRecord::Base
  belongs_to :user
  has_many :files

  validates :report_name, presence: true
  validates :user, presence: true
end
