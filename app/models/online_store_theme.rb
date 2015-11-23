class OnlineStoreTheme < ActiveRecord::Base
  validates :name, presence: true, length: { in: 1..255 }
end
