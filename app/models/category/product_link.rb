class Category::ProductLink < Category::Link
  belongs_to :product, class_name: '::Product', foreign_key: :liitos, primary_key: :tuoteno

  def self.sti_name
    'tuote'
  end
end
