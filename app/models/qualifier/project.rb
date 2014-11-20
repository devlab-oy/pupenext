class Qualifier::Project < Qualifier
  has_many :accounts, foreign_key: :projekti

  default_scope { where(tyyppi: self.sti_name) }

  def self.human_readable_type
    "Projekti"
  end

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "P"
  end

  #Rails figures out paths from the model name. User model has users_path etc.
  #With STI we want to use same name for each child. Thats why we override model_name
  def self.model_name
    Qualifier.model_name
  end
end
