class SumLevel::Profit < SumLevel

  default_scope { where(tyyppi: self.sti_name) }

  def self.sti_name
    'B'
  end
end
