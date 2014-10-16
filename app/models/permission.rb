class Permission < ActiveRecord::Base

  belongs_to :user

  scope :read_access, -> { where.not(paivitys: 1) }
  scope :update_access, -> { where(paivitys: 1) }

  # Map old database schema table to User class
  self.table_name  = "oikeu"
  self.primary_key = "tunnus"

end
