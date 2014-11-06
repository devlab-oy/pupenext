class SumLevel < ActiveRecord::Base

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  self.table_name = 'taso'
  self.primary_key = 'tunnus'
  self.inheritance_column = :tyyppi

  def self.levels
    %w(Internal External Vat Profit)
  end

  def sum_level_name
    "#{taso} #{nimi}"
  end

end
