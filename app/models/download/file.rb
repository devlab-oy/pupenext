class Download::File < ActiveRecord::Base
  belongs_to :download

  validates :data, presence: true
  validates :download, presence: true
  validates :filename, presence: true
end
