class SumLevel::External < SumLevel
  include ActiveModel::Validations

  validates_with SumLevelValidator

  default_scope { where(tyyppi: self.sti_name) }

  def self.sti_name
    'U'
  end
end
