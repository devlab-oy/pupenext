class Download::Download < ActiveRecord::Base
  belongs_to :user
  has_many :files
end
