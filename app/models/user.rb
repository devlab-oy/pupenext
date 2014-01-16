class User < ActiveRecord::Base

  has_one :company, foreign_key: :yhtio, primary_key: :yhtio

  def locale
    locales = %w(fi se en de ee)
    locales.include?(kieli) ? kieli : 'fi'
  end

  # Map old database schema table to User class
  self.table_name  = "kuka"
  self.primary_key = "tunnus"
  self.record_timestamps = false

end
