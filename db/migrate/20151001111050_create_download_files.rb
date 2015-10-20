class CreateDownloadFiles < ActiveRecord::Migration
  def change
    create_table :files do |t|
      t.references :download, index: true
      t.string :filename
      t.binary :data

      t.timestamps null: false
    end
  end
end
