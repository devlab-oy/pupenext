class SumLevel::Internal < SumLevel

  default_scope { where(tyyppi: self.sti_name) }

  def self.sti_name
    'S'
  end
end
