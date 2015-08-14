class Keyword::Package < Keyword
  validates :selitetark, presence: true

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "PAKKAUSKV"
  end

  # Rails figures out paths from the model name. User model has users_path etc.
  # With STI we want to use same name for each child. Thats why we override model_name
  def self.model_name
    Keyword.model_name
  end
end
