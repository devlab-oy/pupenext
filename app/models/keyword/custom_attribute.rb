class Keyword::CustomAttribute < Keyword
  validates :label, presence: true
  validates :set_name, uniqueness: { scope: [:yhtio, :selite] }, presence: true

  validate :invalid_characters

  enum nakyvyys: {
    visible: 'X',
    hidden: '',
  }

  enum selitetark_3: {
    optional: '',
    mandatory: 'PAKOLLINEN',
  }

  alias_attribute :database_field, :selite
  alias_attribute :label,          :selitetark
  alias_attribute :set_name,       :selitetark_2
  alias_attribute :required,       :selitetark_3
  alias_attribute :default_value,  :selitetark_4
  alias_attribute :help_text,      :selitetark_5
  alias_attribute :visibility,     :nakyvyys

  # If user wants to override default validations, store them to db with set_name = 'Default'
  DEFAULT_SET_NAME = 'Default'

  def field
    selite.split('.').last
  end

  def table
    selite.split('.').first
  end

  def alias_set_name
    return if table.blank? || set_name.blank?

    "#{table}+#{set_name}"
  end

  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'MYSQLALIAS'
  end

  def self.fetch_set(table_name:, set_name:)
    where("avainsana.selite like ?", "#{table_name}.%").where(selitetark_2: set_name)
  end

  private

    def invalid_characters
      msg = I18n.t 'errors.messages.invalid'
      errors.add(:set_name, msg) if set_name && set_name.include?("+")
      errors.add(:database_field, msg) if database_field && database_field.include?("+")
    end
end
