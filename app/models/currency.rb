class Currency < ActiveRecord::Base

  has_one :company, foreign_key: :yhtio, primary_key: :yhtio

  self.table_name = "valuu"
  self.primary_key = "tunnus"
  self.record_timestamps = false

  validates :nimi, length: { is: 3 }, uniqueness: { scope: :yhtio }

  before_validation :name_to_uppercase

  protected

    def name_to_uppercase
      self.nimi = nimi.upcase if nimi.is_a? String
    end

end
