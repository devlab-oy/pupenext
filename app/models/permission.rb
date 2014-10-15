class Permission < ActiveRecord::Base

  belongs_to :user

  # Map old database schema table to User class
  self.table_name  = "oikeu"
  self.primary_key = "tunnus"

end
