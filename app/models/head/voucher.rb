class Head::Voucher < Head
  has_one :commodity, class_name: 'FixedAssets::Commodity'
  has_many :rows, foreign_key: :ltunnus, primary_key: :tunnus, class_name: 'Head::VoucherRow'

  validates :tila, inclusion: { in: ['X'] }

  before_save :defaults

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "X"
  end

  def self.find_by_account(account_no)
    joins(:rows).where(tiliointi: { tilino: account_no })
  end

  private

    def defaults
      self.lapvm ||= Date.today
      self.tapvm ||= Date.today
      self.kapvm ||= Date.today
      self.erpcm ||= Date.today
      self.olmapvm ||= Date.today
      self.kerayspvm ||= Date.today
      self.muutospvm ||= Date.today
      self.toimaika ||= Date.today
      self.maksuaika ||= Date.today
      self.lahetepvm ||= Date.today
      self.laskutettu ||= Date.today
      self.h1time ||= Date.today
      self.h2time ||= Date.today
      self.h3time ||= Date.today
      self.h4time ||= Date.today
      self.h5time ||= Date.today
      self.mapvm ||= Date.today
      self.popvm ||= Date.today
      self.puh ||= ''
      self.toim_puh ||= ''
      self.email ||= ''
      self.toim_email ||= ''
      self.alatila ||= ''
    end
end
