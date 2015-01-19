class Accounting::Voucher < ActiveRecord::Base

  has_one :company, foreign_key: :yhtio, primary_key: :yhtio
  has_one :accounting_fixed_assets_commodity, foreign_key: :tunnus, primary_key: :hyodyke_tunnus
  has_many :rows, foreign_key: :ltunnus, primary_key: :tunnus, autosave: true
  has_many :attachments, foreign_key: :liitostunnus, primary_key: :tunnus

  default_scope { where("lasku.tila = 'X'") }

  # Map old database schema table to Accounting::Voucher class
  self.table_name = :lasku
  self.primary_key = :tunnus

  private

    def deactivate_old_rows
      rows.active.update_all(korjattu: 'X', korjausaika: Time.now)
    end
end
