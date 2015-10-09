class CreateDownloads < ActiveRecord::Migration
  def change
    create_table :downloads do |t|
      t.references :user, index: true
      t.string :report_name

      t.timestamps null: false
    end
  end
end
