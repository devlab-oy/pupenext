class User < ActiveRecord::Base

  has_one :company, foreign_key: :yhtio, primary_key: :yhtio

  # Map old database schema table to User class
  self.table_name  = "kuka"
  self.primary_key = "tunnus"
  self.record_timestamps = false

end
