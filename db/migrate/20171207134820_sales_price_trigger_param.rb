class SalesPriceTriggerParam < ActiveRecord::Migration
  def up
    add_column :yhtion_parametrit, :myyntihinnan_muutoksien_logitus, :char, default: '', null: false, after: :myyntihinta_paivitys_saapuminen
  end

  def down
    remove_column :yhtion_parametrit, :myyntihinnan_muutoksien_logitus
  end
end
