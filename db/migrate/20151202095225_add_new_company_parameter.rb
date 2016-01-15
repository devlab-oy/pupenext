class AddNewCompanyParameter < ActiveRecord::Migration
  def change
    add_column :yhtion_parametrit, :laskun_kanavointitiedon_syotto, :tinyint,
               default: 0,
               null:    false,
               after:   :pdf_ruudulle_kieli
  end
end
