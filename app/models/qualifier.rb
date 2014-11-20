class Qualifier < ActiveRecord::Base
  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  validates :nimi, presence: true
  validates :koodi, presence: true
  validates :tyyppi, presence: true

  # Map old database schema table to Qualifier class
  self.table_name = :kustannuspaikka
  self.primary_key = :tunnus
  self.inheritance_column = :tyyppi
  self.abstract_class = true

  def self.default_child_instance
    child_class :P
  end

  def self.sum_levels
    {
      P: Qualifier::Project,
      O: Qualifier::Target,
      K: Qualifier::CostCenter,
    }
  end

  # This functions purpose is to return the child class name.
  # Aka. it should allways return .constantize
  # This function is called from   persistence.rb function: instantiate
  #                             -> inheritance.rb function: discriminate_class_for_record
  # This is the reason we need to map the db column with correct child class in this model
  # type_name = "S", type_name = "U" ...
  def self.find_sti_class(taso_value)
    sum_levels[taso_value.to_sym]
  end

  def nimitys
    "#{koodi} #{nimi}"
  end

  def in_use
    [["Kyllä", "o"], ["Ei", "E"]]
  end

  def types
    [["Kustannuspaikka", "K"], ["Kohde", "O"], ["Projekti", "P"]]
  end

end
