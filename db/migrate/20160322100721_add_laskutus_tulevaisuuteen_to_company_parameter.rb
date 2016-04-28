class AddLaskutusTulevaisuuteenToCompanyParameter < ActiveRecord::Migration
  def change
    add_column :yhtion_parametrit, :laskutus_tulevaisuuteen, :string, limit: 1, null: false, default: '', after: :myyntilaskujen_kurssipaiva
  end
end
