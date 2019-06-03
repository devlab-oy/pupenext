class VapaaTekstiKenttaToimittajanTietoihin < ActiveRecord::Migration
  def up
    add_column :toimi, :vapaa_teksti, :text, null: false, after: :fakta
  end
  def down
    remove_column :toimi, :vapaa_teksti
  end
end
