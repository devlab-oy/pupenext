class CreateIncomingMails < ActiveRecord::Migration
  def change
    create_table :incoming_mails do |t|
      t.text :raw_source, limit: 4294967295
      t.references :mail_server, index: true, foreign_key: true
      t.datetime :processed_at
      t.integer :status
      t.string :status_message

      t.timestamps null: false
    end
  end
end
