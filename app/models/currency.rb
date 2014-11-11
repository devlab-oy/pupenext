class Currency < ActiveRecord::Base
  extend AttributeSanitator
  #With Searchable you can do LIKE searches on db
  extend Searchable

  has_one :company, foreign_key: :yhtio, primary_key: :yhtio

  before_validation :name_to_uppercase
  validates :nimi, length: { is: 3 }, uniqueness: { scope: :yhtio }
  validates :kurssi, numericality: true
  validates :intrastat_kurssi, numericality: true
  validates :jarjestys, numericality: { only_integer: true }

  float_columns :kurssi, :intrastat_kurssi

  # Map old database schema table to Currency class
  self.table_name = :valuu
  self.primary_key = :tunnus

  def self.exact_search(value)
    value[1..-1]
  end

  def self.exact_search?(value)
    value[0].to_s.include? "@"
  end

  protected

    def name_to_uppercase
      self.nimi = nimi.upcase if nimi.is_a? String
    end
end
