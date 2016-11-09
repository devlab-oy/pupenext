class Calendar < ActiveRecord::Base
  self.table_name  = :kalenteri
  self.primary_key = :tunnus
end
