class OnlineStore < ActiveRecord::Base
  include PupenextSingleTableInheritance

  belongs_to :theme, foreign_key: :online_store_theme_id, class_name: 'OnlineStoreTheme'

  has_and_belongs_to_many :products, join_table: :online_stores_products

  validates :name, presence: true, length: { in: 1..255 }

  def to_s
    name
  end

  def self.child_class_names
    [
      OnlineStore::Magento,
      OnlineStore::Pupeshop
    ].index_by(&:to_s)
  end
end
