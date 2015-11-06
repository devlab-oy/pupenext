class PupesoftUserManual < ActiveRecord::Migration
  def up
      add_column :oikeu, :usermanualurl, :string, limit: 255, default: '', null: false, after: :hidden
    end

    def down
      remove_column :oikeu, :usermanualurl
    end
end
