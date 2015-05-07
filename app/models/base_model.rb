class BaseModel < ActiveRecord::Base
  include CurrentCompany

  self.abstract_class = true
end
