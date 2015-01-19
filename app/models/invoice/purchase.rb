class Invoice::Purchase < ActiveRecord::Base
  has_one :company, foreign_key: :yhtio, primary_key: :yhtio
  has_many :accounting_rows, class_name: 'Accounting::Row', foreign_key: :ltunnus

  default_scope { where("lasku.tila = 'H'") }

  # Map old database schema table to Accounting::Attachment class
  self.table_name = :lasku
  self.primary_key = :tunnus

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "H"
  end

  def self.human_readable_type
    "Ostolasku"
  end

  # Rails figures out paths from the model name. User model has users_path etc.
  # With STI we want to use same name for each child. Thats why we override model_name
  def self.model_name
    Invoice.model_name
  end
end
