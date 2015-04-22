class Qualifier < BaseModel
  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  validates :nimi, :koodi, presence: true
  validate :deactivated

  self.table_name = :kustannuspaikka
  self.primary_key = :tunnus
  self.inheritance_column = :tyyppi

  scope :in_use, -> { where(kaytossa: in_use_char) }
  scope :not_in_use, -> { where(kaytossa: not_in_use_char) }

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

  def self.type_options
    qualifiers.map { |v, m| [m.human_readable_type, v] }
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

  # This method is originally defined in inheritance.rb:183 and needs to be overridden, so that
  # rails knows how to initialize a proper subclass because the subclass name is different than the
  # value in the inheritance column.
  def self.subclass_from_attributes(attrs)
    subclass_name = attrs.with_indifferent_access[inheritance_column]
    subclass_name = child_class(subclass_name).to_s

    if subclass_name.present? && subclass_name != self.name
      return subclass_name.safe_constantize
    end

    nil
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
      in_use_char => 'Kyllä',
      not_in_use_char => 'Ei',
    }.invert
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
      # accounts is defined in child models
      errors.add(:kaytossa, msg) if accounts.count > 0
    end
  end
end
