class Keyword < BaseModel
  include PupenextSingleTableInheritance

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  self.table_name = :avainsana
  self.primary_key = :tunnus
  self.inheritance_column = :laji

  validates :selite, presence: true

  def self.default_child_instance
    child_class 'PAKKAUSKV'
  end

  def self.child_class_names
    {
      'PAKKAUSKV' => Keyword::Package
    }
  end
end
