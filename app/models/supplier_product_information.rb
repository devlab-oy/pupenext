class SupplierProductInformation < ActiveRecord::Base
  include Searchable

  belongs_to :dynamic_tree, foreign_key: :p_tree_id
  belongs_to :product, foreign_key: :p_product_id
  belongs_to :supplier

  validates :product_id,               length: { maximum: 100 }, presence: true
  validates :product_name,             length: { maximum: 150 }
  validates :manufacturer_ean,         length: { maximum: 13 }
  validates :manufacturer_name,        length: { maximum: 100 }
  validates :manufacturer_id,          length: { maximum: 10 }
  validates :manufacturer_part_number, length: { maximum: 100 }
  validates :supplier_name,            length: { maximum: 100 }
  validates :supplier_id,              length: { maximum: 10 }
  validates :supplier_ean,             length: { maximum: 13 }
  validates :supplier_part_number,     length: { maximum: 100 }
  validates :product_status,           length: { maximum: 100 }
  validates :short_description,        length: { maximum: 250 }
  validates :description,              length: { maximum: 500 }
  validates :category_text1,           length: { maximum: 100 }
  validates :category_text2,           length: { maximum: 100 }
  validates :category_text3,           length: { maximum: 100 }
  validates :category_text4,           length: { maximum: 100 }
  validates :warranty_text,            length: { maximum: 100 }
  validates :packaging_unit,           length: { maximum: 100 }
  validates :url_to_product,           length: { maximum: 150 }
  validates :p_nakyvyys,               length: { maximum: 100 }

  def self.category_texts(number)
    category_text = "category_text#{number}"

    select(category_text).distinct.order(category_text)
  end
end
