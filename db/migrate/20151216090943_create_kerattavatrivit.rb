class CreateKerattavatrivit < ActiveRecord::Migration
  def change
    create_table :kerattavatrivit do |t|
      t.integer :tilausrivi_id
      t.string  :hyllyalue
      t.string  :hyllynro
      t.string  :hyllyvali
      t.string  :hyllytaso
      t.decimal :poikkeava_maara
      t.string :poikkeama_kasittely
      t.boolean :keratty

      t.timestamps null: false
    end

    add_index :kerattavatrivit, :tilausrivi_id, unique: true, name: 'tilausrivi_id_index'
  end
end
