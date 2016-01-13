class PdfOnScreenLanguage < ActiveRecord::Migration
  def up
    add_column :yhtion_parametrit, :pdf_ruudulle_kieli, :string, limit: 1, default: '', null: false, after: :viitemaksujen_oikaisut
  end

  def down
    remove_column :yhtion_parametrit, :pdf_ruudulle_kieli
  end
end
