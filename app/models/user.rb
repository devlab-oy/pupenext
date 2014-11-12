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

  #TODO Currently assing and revoke methods are only called from tests
  #For this reason we allways assing resource permissions to sovellus = 'test'
  def assing_update_access(resource)
    permission = Permission.find_or_create_by(
      sovellus: '',
      nimi: resource,
      alanimi: '',
      lukittu: '',
      nimitys: '',
      user: self,
      yhtio: company.yhtio
    )

    permission.paivitys = 1

    permission.save
  end

  def revoke_update_access(resource)
    permission = Permission.find_or_create_by(
      sovellus: '',
      nimi: resource,
      alanimi: '',
      lukittu: '',
      nimitys: '',
      user: self,
      yhtio: company.yhtio
    )

    permission.paivitys = 0

    permission.save
  end

  def assing_read_access(resource)
    revoke_update_access resource
  end

  def revoke_all(resource)
    permissions = Permission.where(
      nimi: resource,
      alanimi: '',
      nimitys: '',
      user: self,
      yhtio: company.yhtio
    )

    permissions.delete_all
  end

  # Map old database schema table to User class
  self.table_name = "kuka"
  self.primary_key = "tunnus"
end
