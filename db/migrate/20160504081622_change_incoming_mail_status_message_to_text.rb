class ChangeIncomingMailStatusMessageToText < ActiveRecord::Migration
  def change
    change_column :incoming_mails, :status_message, :text
  end
end
