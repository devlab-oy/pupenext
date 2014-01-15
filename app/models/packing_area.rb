class PackingArea < ActiveRecord::Base

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  validates :nimi, presence: true
  validates :lokero, presence: true
  validates :prio, presence: true
  validates :pakkaamon_prio, presence: true
  validates :varasto, presence: true
  validates :printteri0, presence: true
  validates :printteri1, presence: true
  validates :printteri2, presence: true
  validates :printteri3, presence: true
  validates :printteri4, presence: true
  validates :printteri6, presence: true
  validates :printteri7, presence: true

  before_create :update_created
  before_update :update_modified

  # Map old database schema table to Qualifier class
  self.table_name  = "pakkaamo"
  self.primary_key = "tunnus"
  self.record_timestamps = false

  private

    def update_created
      self.luontiaika = DateTime.now
      self.muutospvm = DateTime.now
    end

    def update_modified
      self.muutospvm = DateTime.now
    end


end
