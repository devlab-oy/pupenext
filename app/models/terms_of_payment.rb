class TermsOfPayment < ActiveRecord::Base

  include Validators

  validates :rel_pvm,
    :kassa_relpvm,
    :osamaksuehto1,
    :osamaksuehto2,
    :pankkiyhteystiedot,
    :jarjestys, numericality: { only_integer: true }

  validates :jv,
    :kateinen,
    :suoraveloitus,
    :itsetulostus,
    :jaksotettu,
    :erapvmkasin,
    :kaytossa, presence: true, allow_blank: true, length: { is: 1 }

  validates :teksti, presence: true, length: { within: 1..40 }, allow_blank: false
  validates :factoring, :sallitut_maat, length: { within: 1..50 }, allow_blank: true
  validates :kassa_alepros, :summanjakoprososa2, numericality: true
  validates :yhtio, presence: true

  validate do |top|
    valid_date :abs_pvm, top.abs_pvm
    valid_date :kassa_abspvm, top.kassa_abspvm
  end

  before_create :update_created
  before_update :update_modified

  self.table_name = "maksuehto"
  self.primary_key = "tunnus"
  self.record_timestamps = false

  private

    def update_created
      self.luontiaika = Date.today
      self.muutospvm = Date.today
    end

    def update_modified
      self.muutospvm = Date.today
    end

end
