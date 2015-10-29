class ChangeDataTypeInDownloadFiles < ActiveRecord::Migration
  def change
    change_column :files, :data, :longblob
  end
end
