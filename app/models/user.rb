class User < ActiveRecord::Base

  has_one :company, foreign_key: :yhtio, primary_key: :yhtio
  has_many :permissions

  def locale
    locales = %w(fi se en de ee)
    locales.include?(kieli) ? kieli : 'fi'
  end

  def can_read?(resource)
    Rails.cache.fetch("read-#{id}-#{resource}", expires_in: 5.minutes) do
      permissions.read_access(resource).present?
    end
  end

  def can_update?(resource)
    Rails.cache.fetch("update-#{id}-#{resource}", expires_in: 5.minutes) do
      permissions.update_access(resource).present?
    end
  end

  # Map old database schema table to User class
  self.table_name = "kuka"
  self.primary_key = "tunnus"
end
