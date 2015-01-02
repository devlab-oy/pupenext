class Qualifier::Target < Qualifier
  has_many :accounts, foreign_key: :kohde

  def self.human_readable_type
    "Kohde"
  end

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "O"
  end

  #Rails figures out paths from the model name. User model has users_path etc.
  #With STI we want to use same name for each child. Thats why we override model_name
  def self.model_name
    Qualifier.model_name
  end
end
