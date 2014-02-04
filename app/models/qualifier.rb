class Qualifier < ActiveRecord::Base

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  validates :nimi, presence: true
  validates :koodi, presence: true
  validates :tyyppi, presence: true

  # Map old database schema table to Qualifier class
  self.table_name  = "kustannuspaikka"
  self.primary_key = "tunnus"

  def nimitys
    "#{koodi} #{nimi}"
  end

  def in_use
    [ ["Kyllä", "o"], ["Ei", "E"] ]
  end

  def types
    [ ["Kustannuspaikka", "K"], ["Kohde", "O"], ["Projekti", "P"] ]
  end

end
