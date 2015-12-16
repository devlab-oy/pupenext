class CreateKerattavatrivit < ActiveRecord::Migration
  def change
    create_table :kerattavatrivit do |t|
      t.references :tilausrivi, index: true
      t.string :hyllyalue
      t.string :hyllynro
      t.string :hyllyvali
      t.string :hyllytaso
      t.decimal :poikkeava_maara
      t.string :poikkeama_kasittely
      t.boolean :keratty

      t.timestamps null: false
    end
  end
end
