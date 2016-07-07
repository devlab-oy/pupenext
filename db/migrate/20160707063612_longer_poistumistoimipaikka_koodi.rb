class LongerPoistumistoimipaikkaKoodi < ActiveRecord::Migration
  def up
    change_column :toimitustapa,  :poistumistoimipaikka_koodi, :string, limit: 8, default: '',  null: false
    change_column :varastopaikat, :poistumistoimipaikka_koodi, :string, limit: 8, default: '',  null: false
  end

  def down
    change_column :toimitustapa,  :poistumistoimipaikka_koodi, :string, limit: 3, default: '',  null: false
    change_column :varastopaikat, :poistumistoimipaikka_koodi, :string, limit: 3, default: '',  null: false
  end
end
