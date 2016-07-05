class BaseModel < ActiveRecord::Base
  self.abstract_class = true

  def self.inherited(subclass)
    super

    unless subclass.abstract_class?
      subclass.class_eval do
        include CurrentCompany
        include CurrentUser
        include UserDefinedValidations
        include DateDatetimeDefaults

        before_create :set_date_fields
        after_create :fix_datetime_fields
      end
    end
  end
end
