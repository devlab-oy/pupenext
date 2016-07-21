class Category::Link < BaseModel
  include PupenextSingleTableInheritance

  self.table_name         = :puun_alkio
  self.primary_key        = :tunnus
  self.inheritance_column = :laji

  belongs_to :category, foreign_key: :puun_tunnus

  before_save :defaults

  def self.default_child_instance
    child_class :tuote
  end

  def self.child_class_names
    { tuote: Category::ProductLink }.stringify_keys
  end

  private

    def defaults
      self.kutsuja ||= ''
    end
end
