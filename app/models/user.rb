class User < ActiveRecord::Base
  has_one :company, foreign_key: :yhtio, primary_key: :yhtio
  has_many :permissions

  def locale
    locales = %w(fi se en de ee)
    locales.include?(kieli) ? kieli : 'fi'
  end

  def can_read?(resource)
    permissions.read_access(resource).present?
  end

  def can_update?(resource)
    permissions.update_access(resource).present?
  end

  def classic_ui?
    kayttoliittyma == 'C' || (kayttoliittyma.blank? && company.classic_ui?)
  end

  # Map old database schema table to User class
  self.table_name = "kuka"
  self.primary_key = "tunnus"
end
