class YhteyshenkilotUpdate < ActiveRecord::Migration
  def change
    add_column :yhteyshenkilo, :aktivointikuittaus, :string, limit: 1, default: '', null: false
  end
end
