class FixedAssets::Commodity < ActiveRecord::Base
  belongs_to :company
  has_many :commodity_rows
end
