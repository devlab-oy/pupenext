class Arrival < Head
  has_many :rows, foreign_key: :uusiotunnus, class_name: 'PurchaseOrder::Row'

  validates :tila, inclusion: { in: ['K'] }

  def self.sti_name
    'K'
  end
end
