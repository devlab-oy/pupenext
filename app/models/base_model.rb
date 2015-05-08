class BaseModel < ActiveRecord::Base
  include CurrentCompany

  validates :muuttaja, presence: true, unless: :table_does_not_have_company?
  validates :laatija, presence: true, unless: :table_does_not_have_company?
  before_save :set_legacy_timestamps

  self.abstract_class = true

  def save_by(user)
    raise ArgumentError, "Should pass User -class" unless user.kind_of? User

    if self.respond_to?(:created_by=) && self.respond_to?(:modified_by=)
      touch_modern_columns(user)
    else
      touch_antique_columns(user)
    end

    self.save
  end

  def update_by(params, user)
    raise ArgumentError, "Should pass User -class" unless user.kind_of? User

    if self.respond_to?(:modified_by=) && self.respond_to?(:created_by=)
      touch_modern_columns(user)
    else
      touch_antique_columns(user)
    end

    self.update params
  end

  private

  def touch_modern_columns(user)
    self.created_by  = user.kuka unless self.persisted? && self.created_by.present?
    self.modified_by = user.kuka
  end

  def touch_antique_columns(user)
    self.laatija  = user.kuka unless self.persisted? && self.laatija.present?
    self.muuttaja = user.kuka if self.respond_to?(:muuttaja=)
  end

  def set_legacy_timestamps
    if self.respond_to?(:luontiaika=) && self.respond_to?(:muutospvm=)
      self.luontiaika = Time.now unless self.persisted? && self.luontiaika.present?
      self.muutospvm  = Time.now
    end
  end

  def table_does_not_have_company?
    %w{
        fixed_assets_commodities
        fixed_assets_commodity_rows
        git_paivitykset
        git_pulkkarit
        karhu_lasku
        maat
        schema_migrations
        taric_veroperusteet
        tiliointi
        valuu_historia
      }.include? self.class.table_name
  end
end
