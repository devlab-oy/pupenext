class Country < ActiveRecord::Base
  self.table_name  = :maat
  self.primary_key = :tunnus
end
