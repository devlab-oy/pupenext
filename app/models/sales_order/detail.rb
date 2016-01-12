class SalesOrder::Detail < Head
  has_many :rows, foreign_key: :otunnus, class_name: 'SalesOrder::DetailRow'
  belongs_to :customer, foreign_key: :liitostunnus

  validates :customer, presence: true
  validates :tila, inclusion: { in: ['9'] }

  before_create :set_customer_defaults

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "9"
  end

  private

    def set_customer_defaults
      # Set customer's name & address & other info
      self.nimi           = customer.nimi           if nimi.blank?
      self.nimitark       = customer.nimitark       if nimitark.blank?
      self.osoite         = customer.osoite         if osoite.blank?
      self.postino        = customer.postino        if postino.blank?
      self.postitp        = customer.postitp        if postitp.blank?
      self.maa            = customer.maa            if maa.blank?
      self.toim_nimi      = customer.toim_nimi      if toim_nimi.blank?
      self.toim_nimitark  = customer.toim_nimitark  if toim_nimitark.blank?
      self.toim_osoite    = customer.toim_osoite    if toim_osoite.blank?
      self.toim_postino   = customer.toim_postino   if toim_postino.blank?
      self.toim_postitp   = customer.toim_postitp   if toim_postitp.blank?
      self.toim_maa       = customer.toim_maa       if toim_maa.blank?
      self.ytunnus        = customer.ytunnus        if ytunnus.blank?
      self.piiri          = customer.piiri          if piiri.blank?
      self.toim_ovttunnus = customer.toim_ovttunnus if toim_ovttunnus.blank?
      self.puh            = customer.puhelin        if puh.blank?
      self.email          = customer.email          if email.blank?
      self.toimitusehto   = customer.toimitusehto   if toimitusehto.blank?
    end
end
