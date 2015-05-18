class BaseModel < ActiveRecord::Base
  self.abstract_class = true

  def self.inherited(subclass)
    super

    unless subclass.abstract_class?
      subclass.class_eval do
        include CurrentCompany
        include SaveByExtension
      end
    end
  end
end
