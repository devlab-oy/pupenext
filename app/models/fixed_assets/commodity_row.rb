class FixedAssets::CommodityRow < ActiveRecord::Base
  belongs_to :commodity

  default_scope { where(amended: false) }

  def self.locked
    where(locked: true)
  end

  def self.unlocked
    where(locked: false)
  end

end
