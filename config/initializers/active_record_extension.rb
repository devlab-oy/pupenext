module ActiveRecordExtension

  extend ActiveSupport::Concern

  included do
    validates :yhtio, presence: true
    validates :muuttaja, presence: true
    validates :laatija, presence: true

    before_save :set_legacy_timestamps
  end

  def save_by(user)
    raise ArgumentError, "Should pass User -class"  unless user.kind_of? User

    self.muuttaja = user.kuka
    self.laatija = user.kuka unless self.persisted?
    self.save
  end

  def update_by(params, user)
    raise ArgumentError, "Should pass User -class" unless user.kind_of? User

    self.muuttaja = user.kuka
    self.laatija = user.kuka unless self.persisted?
    self.update params
  end

  private

    def set_legacy_timestamps
      self.luontiaika = Time.now unless self.persisted?
      self.muutospvm = Time.now
    end

end

ActiveRecord::Base.send(:include, ActiveRecordExtension)
