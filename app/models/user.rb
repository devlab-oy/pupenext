class User < BaseModel
  has_many :downloads, class_name: 'Download::Download'
  has_many :files, through: :downloads, class_name: 'Download::File'
  has_many :permissions, -> { where(profiili: '').where.not(kuka: '') }

  self.table_name = :kuka
  self.primary_key = :tunnus

  def locale
    locales = %w(fi se en de ee)
    locales.include?(kieli) ? kieli : 'fi'
  end

  def can_read?(resource, options = {})
    permissions.read_access(resource, options).present?
  end

  def can_update?(resource, options = {})
    permissions.update_access(resource, options).present?
  end

  def classic_ui?
    kayttoliittyma == 'C' || (kayttoliittyma.blank? && company.classic_ui?)
  end
end
