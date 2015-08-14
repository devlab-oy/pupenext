class Qualifier < BaseModel
  include PupenextSingleTableInheritance
  include Searchable

  self.table_name = :kustannuspaikka
  self.primary_key = :tunnus
  self.inheritance_column = :tyyppi

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  validates :nimi, presence: true
  validate :deactivation_allowed

  scope :code_name_order, -> { order("koodi+0, nimi") }

  enum kaytossa: {
    in_use: 'o',
    not_in_use: 'E'
  }

  def self.default_child_instance
    child_class 'P'
  end

  def self.child_class_names
    {
      'P' => Qualifier::Project,
      'O' => Qualifier::Target,
      'K' => Qualifier::CostCenter,
    }
  end

  def nimitys
    "#{koodi} #{nimi}"
  end

  private

    def deactivation_allowed
      msg = I18n.t 'errors.qualifier.accounts_found'
      errors.add(:kaytossa, msg) if not_in_use? && accounts.count > 0
    end
end
