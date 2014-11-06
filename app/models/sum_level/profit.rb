class SumLevel::Profit < SumLevel

  validates :taso, numericality: { only_integer: true }

  default_scope { where(tyyppi: self.sti_name) }

  def self.sti_name
    'B'
  end
end
