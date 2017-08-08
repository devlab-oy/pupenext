class TuotteenAvainsanaindex < ActiveRecord::Migration
  def change
    add_index :tuotteen_avainsanat, [:yhtio, :kieli, :laji, :selite], name: "yhtio_kieli_laji_selite", length: {selite: 150}
  end
end
