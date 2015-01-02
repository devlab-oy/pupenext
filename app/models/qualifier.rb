class Qualifier < ActiveRecord::Base
  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  validates :nimi, presence: true
  validate :deactivated

  # Map old database schema table to Qualifier class
  self.table_name = :kustannuspaikka
  self.primary_key = :tunnus
  self.inheritance_column = :tyyppi

  default_scope { where(kaytossa: in_use_char) }
  scope :not_in_use, -> { unscoped.where(kaytossa: not_in_use_char) }

  def self.child_class(tyyppi_value)
    qualifiers[tyyppi_value.try(:to_sym)]
  end

  def self.default_child_instance
    child_class :P
  end

  def self.qualifiers
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
  def self.find_sti_class(tyyppi_value)
    child_class tyyppi_value
  end

  def nimitys
    "#{koodi} #{nimi}"
  end

  def self.not_in_use_char
    "E"
  end

  def self.in_use_char
    "o"
  end

  def self.kaytossa_options
    {
      in_use_char => t('Kyllä'),
      not_in_use_char => t('Ei'),
    }
  end

  def deactivate!
    self.kaytossa = Qualifier.not_in_use_char
  end

  def activate!
    self.kaytossa = Qualifier.in_use_char
  end

  def deactivated
    msg = 'Et voi ottaa pois käytöstä, koska kustannuspaikalla on tilejä'
    if kaytossa == 'E'
      #accounts is defined in child models
      errors.add(:kaytossa, msg) if accounts.count > 0
    end
  end
end
