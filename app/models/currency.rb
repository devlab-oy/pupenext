class Currency < ActiveRecord::Base

  has_one :company, foreign_key: :yhtio, primary_key: :yhtio

  before_validation :name_to_uppercase
  validates :nimi, length: { is: 3 }, uniqueness: { scope: :yhtio }

  def self.search_like(args)
    result = self.all

    args.each do |key,value|
      if exact_search? value
        value = exact_search value
        result = where(key => value)
      else
        result = where_like key, value
      end
    end

    result
  end

  def self.where_like(column, search_term)
    where(self.arel_table[column].matches "%#{search_term}%")
  end

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

  # Map old database schema table to Currency class
  self.table_name = :valuu
  self.primary_key = :tunnus

end
