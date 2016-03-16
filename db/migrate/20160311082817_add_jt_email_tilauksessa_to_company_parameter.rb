class AddJtEmailTilauksessaToCompanyParameter < ActiveRecord::Migration
  def change
    add_column :yhtion_parametrit, :jt_email_tilauksessa, :string, limit: 1, null: false, default: '', after: :jt_siirtolistojen_yhdistaminen
  end
end
