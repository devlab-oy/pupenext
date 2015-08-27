class Keyword::CustomAttribute < Keyword
  validates :selitetark, presence: true
  validates :selitetark_2, uniqueness: { scope: [:selite] }

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

  def field
    selite.split('.').last
  end

  def table
    selite.split('.').first
  end

  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'MYSQLALIAS'
  end

  def self.fetch_set(table_name:, set_name:)
    where("avainsana.selite like ?", "#{table_name}.%").where(selitetark_2: set_name)
  end
end
