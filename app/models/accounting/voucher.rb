class Accounting::Voucher < ActiveRecord::Base

  has_one :company, foreign_key: :yhtio, primary_key: :yhtio
  has_one :accounting_fixed_assets_commodity, foreign_key: :tunnus, primary_key: :hyodyke_tunnus
  has_many :rows, foreign_key: :ltunnus, primary_key: :tunnus, autosave: true
  has_many :attachments, foreign_key: :liitostunnus, primary_key: :tunnus

  default_scope { where(tila: 'X') }

  # Map old database schema table to Accounting::Voucher class
  self.table_name  = :lasku
  self.primary_key = :tunnus

  def create_voucher_row(params)
    tiliointi_params = {
      laatija: params[:laatija],
      muuttaja: params[:muuttaja],
      tapvm: params[:tapvm],
      yhtio: params[:yhtio],
      summa: params[:summa],
      selite: params[:selite],
      tilino: params[:tilino],
      laadittu: Date.today,
      korjausaika: Date.today
    }
    rows.build tiliointi_params
  end

  def deactivate_old_rows
    rows.active.update_all(korjattu: 'X', korjausaika: Time.now)
  end

end
