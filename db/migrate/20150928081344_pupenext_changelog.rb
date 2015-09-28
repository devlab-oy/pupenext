class PupenextChangelog < ActiveRecord::Migration
  def change
      add_column :git_pulkkarit, :repository, :string, limit: 20, default: 'pupesoft', null: false, after: :id
      add_column :git_paivitykset, :repository, :string, limit: 20, default: 'pupesoft', null: false, after: :hash
      add_column :git_paivitykset, :hash_pupenext, :string, limit: 50, default: '', null: false, after: :hash
      rename_column :git_paivitykset, :hash, :hash_pupesoft
    end
end
