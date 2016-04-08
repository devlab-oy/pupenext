class CreateMailServers < ActiveRecord::Migration
  def change
    create_table :mail_servers do |t|
      t.string :imap_server
      t.string :imap_username
      t.string :imap_password
      t.string :smtp_server
      t.string :smtp_username
      t.string :smtp_password
      t.string :process_dir
      t.string :done_dir
      t.string :processing_type
      t.references :company, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
