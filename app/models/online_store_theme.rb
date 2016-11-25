class OnlineStoreTheme < ActiveRecord::Base
  has_many :online_stores

  validates :name, presence: true, length: { in: 1..255 }

  def to_s
    name
  end
end
