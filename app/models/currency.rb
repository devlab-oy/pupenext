class Currency < ActiveRecord::Base

  has_one :company, foreign_key: :yhtio, primary_key: :yhtio

  self.table_name = "valuu"
  self.primary_key = "tunnus"
  self.record_timestamps = false

  validates :nimi, length: { is: 3 }, uniqueness: { scope: :yhtio }

  before_validation :name_to_uppercase
  before_create :update_created
  before_update :update_modified

  protected
    def name_to_uppercase
        self.nimi = self.nimi.upcase if self.nimi.is_a? String
    end

  private

    def update_created
      self.luontiaika = Date.today
      self.muutospvm = Date.today
    end

    def update_modified
      self.muutospvm = Date.today
    end
end
