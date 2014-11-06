class SumLevel::External < SumLevel

  default_scope { where(tyyppi: self.sti_name) }

  def self.sti_name
    'U'
  end
end
