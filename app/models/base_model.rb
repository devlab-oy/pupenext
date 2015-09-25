class BaseModel < ActiveRecord::Base
  self.abstract_class = true

  def self.inherited(subclass)
    super

    unless subclass.abstract_class?
      subclass.class_eval do
        include CurrentCompany
        include CurrentUser
        include UserDefinedValidations
      end
    end
  end
end
