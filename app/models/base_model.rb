class BaseModel < ActiveRecord::Base
  self.abstract_class = true

  def self.inherited(subclass)
    super

    unless subclass.abstract_class?
      subclass.class_eval do
        include CurrentCompany
        include CurrentUser
        include DateDatetimeDefaults

        before_save :set_date_fields
        after_save :fix_datetime_fields
      end
    end
  end
end
