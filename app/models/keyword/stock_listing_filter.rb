class Keyword::StockListingFilter < Keyword
  scope :brand,       -> { where(selite: 'tuotemerkki') }
  scope :subcategory, -> { where(selite: 'try') }
  scope :category,    -> { where(selite: 'osasto') }

  scope :include,     -> { where(selitetark: 'on') }
  scope :exclude,     -> { where(selitetark: 'off') }

  def self.sti_name
    :STCK_LST_FLTR
  end

  def self.brands_to_include
    brands_to_include = brand.include.pluck(:selitetark_2)
    brands_to_include.empty? && brands_to_include = Product::Brand.all.pluck(:selite)
    brands_to_exclude = brand.exclude.pluck(:selitetark_2)

    brands_to_include - brands_to_exclude
  end

  def self.subcategories_to_include
    subcategories_to_include = subcategory.include.pluck(:selitetark_2)
    subcategories_to_include.empty? && subcategories_to_include = Product::Subcategory.all.pluck(:selite)
    subcategories_to_exclude = subcategory.exclude.pluck(:selitetark_2)

    subcategories_to_include - subcategories_to_exclude
  end

  def self.categories_to_include
    categories_to_include = category.include.pluck(:selitetark_2)
    categories_to_include.empty? && categories_to_include = Product::Category.all.pluck(:selite)
    categories_to_exclude = category.exclude.pluck(:selitetark_2)

    categories_to_include - categories_to_exclude
  end
end
