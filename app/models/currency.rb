class Currency < ActiveRecord::Base

  has_one :company, foreign_key: :yhtio, primary_key: :yhtio

  before_validation :name_to_uppercase
  validates :nimi, length: { is: 3 }, uniqueness: { scope: :yhtio }

  protected

    def name_to_uppercase
      self.nimi = nimi.upcase if nimi.is_a? String
    end

  # Map old database schema table to Currency class
  self.table_name = :valuu
  self.primary_key = :tunnus

end
