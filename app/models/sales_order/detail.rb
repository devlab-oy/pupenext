class SalesOrder::Detail < Head
  has_many :rows, foreign_key: :otunnus, class_name: 'SalesOrder::DetailRow'
  belongs_to :customer, foreign_key: :liitostunnus

  validates :tila, inclusion: { in: ['9'] }

  before_create :set_defaults

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "9"
  end

  private

    def set_defaults
      # Date fields can be set to zero
      self.erpcm    ||= 0
      self.kapvm    ||= 0
      self.lapvm    ||= 0
      self.mapvm    ||= 0
      self.olmapvm  ||= 0
      self.tapvm    ||= 0
      self.toimaika ||= 0

      # Datetime fields don't accept zero, so let's set them to epoch zero (temporarily)
      self.h1time     ||= Time.at(0)
      self.h2time     ||= Time.at(0)
      self.h3time     ||= Time.at(0)
      self.h4time     ||= Time.at(0)
      self.h5time     ||= Time.at(0)
      self.kerayspvm  ||= Time.at(0)
      self.lahetepvm  ||= Time.at(0)
      self.laskutettu ||= Time.at(0)
      self.maksuaika  ||= Time.at(0)
      self.popvm      ||= Time.at(0)

      # Set customer's name & address & other info
      self.nimi           = customer.nimi           if self.nimi.blank?
      self.nimitark       = customer.nimitark       if self.nimitark.blank?
      self.osoite         = customer.osoite         if self.osoite.blank?
      self.postino        = customer.postino        if self.postino.blank?
      self.postitp        = customer.postitp        if self.postitp.blank?
      self.maa            = customer.maa            if self.maa.blank?
      self.toim_nimi      = customer.toim_nimi      if self.toim_nimi.blank?
      self.toim_nimitark  = customer.toim_nimitark  if self.toim_nimitark.blank?
      self.toim_osoite    = customer.toim_osoite    if self.toim_osoite.blank?
      self.toim_postino   = customer.toim_postino   if self.toim_postino.blank?
      self.toim_postitp   = customer.toim_postitp   if self.toim_postitp.blank?
      self.toim_maa       = customer.toim_maa       if self.toim_maa.blank?
      self.ytunnus        = customer.ytunnus        if self.ytunnus.blank?
      self.piiri          = customer.piiri          if self.piiri.blank?
      self.toim_ovttunnus = customer.toim_ovttunnus if self.toim_ovttunnus.blank?
      self.puh            = customer.puhelin        if self.puh.blank?
      self.email          = customer.email          if self.email.blank?
      self.toimitusehto   = customer.toimitusehto   if self.toimitusehto.blank?
    end
end
