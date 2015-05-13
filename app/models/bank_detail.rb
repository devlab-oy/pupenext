class BankDetail < BaseModel
  include Searchable
  extend Translatable

  validates :nimitys, presence: true
  validates :viite, inclusion: { in: %w(SE) }, allow_blank: true

  self.table_name = :pankkiyhteystiedot
  self.primary_key = :tunnus
  self.record_timestamps = false

  class << self
    def viite_options
      [[t("Suomi"), ""], [t("Ruotsi"), "SE"]]
    end
  end
end
