class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :name, limit: 60, default: '', null: false
      t.string :description, limit: 255, default: '', null: false
      t.boolean :active, default: true, null: false
      t.references :company, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
