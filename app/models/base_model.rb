class BaseModel < ActiveRecord::Base
  include SaveByExtension
  include CurrentCompany

  self.abstract_class = true
end
