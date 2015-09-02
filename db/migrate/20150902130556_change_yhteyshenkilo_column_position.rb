class ChangeYhteyshenkiloColumnPosition < ActiveRecord::Migration
  def change
    change_column :yhteyshenkilo, :aktivointikuittaus, :string, limit: 1, default: '', null: false, after: :oletusyhteyshenkilo
  end
end
