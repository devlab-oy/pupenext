class PurchaseOrder < ActiveRecord::Base

  has_one :company, foreign_key: :yhtio, primary_key: :yhtio

  # Only paid purchase orders for now
  default_scope { where("tila in('H','Y','M','P','Q') and mapvm > 0") }
  #scope :paid, -> { where("tila in('H','Y','M','P','Q') and mapvm > 0") }

  # Map old database schema table to Accounting::Attachment class
  self.table_name  = :lasku
  self.primary_key = :tunnus

  def self.search_like(args)
    result = self.all

    args.each do |key,value|
      if exact_search? value
        value = exact_search value
        result = where(key => value)
      else
        result = where_like key, value
      end
    end

    result
  end

  def self.where_like(column, search_term)
    where(self.arel_table[column].matches "%#{search_term}%")
  end

  def self.exact_search(value)
    value[1..-1]
  end

  def self.exact_search?(value)
    value[0].to_s.include? "@"
  end

  def save_commodity_id(commodity_id)
    self.hyodyke_tunnus = commodity_id || 0
    self.muuttaja = 'CommoditiesController'
    save
  end
end
