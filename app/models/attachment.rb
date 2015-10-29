class Attachment < BaseModel
  include PupenextSingleTableInheritance

  validates :data, presence: true

  self.table_name         = :liitetiedostot
  self.primary_key        = :tunnus
  self.inheritance_column = :liitos

  def self.child_class_names
    {
      tuote:    Attachment::ProductAttachment,
      Yllapito: Attachment::AdministrationAttachment
    }.stringify_keys
  end

  def self.default_child_instance
    child_class :ProductAttachment
  end
end
