class SumLevel::Vat < SumLevel

  default_scope { where(tyyppi: self.sti_name) }

  def self.sti_name
    'A'
  end
end
