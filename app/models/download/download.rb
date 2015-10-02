class Download::Download < ActiveRecord::Base
  belongs_to :user
  has_many :files, dependent: :destroy

  validates :report_name, presence: true
  validates :user, presence: true
end
