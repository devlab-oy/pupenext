class Head::Voucher < Head
  belongs_to :commodity, class_name: 'FixedAssets::Commodity'
  has_many :rows, foreign_key: :ltunnus, primary_key: :tunnus, class_name: 'Head::VoucherRow'

  validates :tila, inclusion: { in: ['X'] }

  before_save :defaults

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "X"
  end

  def self.human_readable_type
    "Tosite"
  end

  # Rails figures out paths from the model name. User model has users_path etc.
  # With STI we want to use same name for each child. Thats why we override model_name
  def self.model_name
    Head.model_name
  end

  private

    def deactivate_old_rows
      rows.active.update_all(korjattu: 'X', korjausaika: Time.now)
    end

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
    end
end
