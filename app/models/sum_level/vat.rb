class SumLevel::Vat < SumLevel
  has_many :accounts, foreign_key: :alv_taso

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    'A'
  end

  def self.human_readable_type
    "ALV"
  end

  #Rails figures out paths from the model name. User model has users_path etc.
  #With STI we want to use same name for each child. Thats why we override model_name
  def self.model_name
    SumLevel.model_name
  end
end
