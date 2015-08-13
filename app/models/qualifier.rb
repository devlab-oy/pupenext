class Qualifier < BaseModel
  include Searchable

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  validates :nimi, presence: true
  validate :deactivated

  self.table_name = :kustannuspaikka
  self.primary_key = :tunnus
  self.inheritance_column = :tyyppi

  scope :code_name_order, -> { order("koodi+0, nimi") }

  enum kaytossa: {
    in_use: 'o',
    not_in_use: 'E'
  }

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

  private

    def deactivated
      if not_in_use?
        msg = I18n.t 'errors.qualifier.accounts_found'
        errors.add(:kaytossa, msg) if accounts.count > 0
      end
    end
end
