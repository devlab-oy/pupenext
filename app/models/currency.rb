class Currency < ActiveRecord::Base

  has_one :company, foreign_key: :yhtio, primary_key: :yhtio

  validates :nimi, length: { is: 3 }, uniqueness: { scope: :yhtio }
  before_validation :ensure_nimi_is_uppercase

  self.table_name = "valuu"
  self.primary_key = "tunnus"
  self.record_timestamps = false

  protected
    def ensure_nimi_is_uppercase
        self.nimi = self.nimi.upcase if self.nimi.is_a? String
    end
end
