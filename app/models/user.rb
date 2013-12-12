class User < ActiveRecord::Base

  # Map old database schema table to User class
  self.table_name  = "kuka"
  self.primary_key = "tunnus"
  self.record_timestamps = false

end
