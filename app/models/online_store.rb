class OnlineStore < ActiveRecord::Base
  belongs_to :theme, foreign_key: :online_store_theme_id, class_name: 'OnlineStoreTheme'
end
