class BaseModel < ActiveRecord::Base
  include CurrentCompany
  include SaveByExtension
  
  self.abstract_class = true
end
