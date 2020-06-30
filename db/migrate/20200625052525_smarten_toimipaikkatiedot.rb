class SmartenToimipaikkatiedot < ActiveRecord::Migration
  def up
    add_column :yhtion_toimipaikat, :varastotoimipaikka, :string, limit: 1, default: '', null: false, after: :vat_numero
    add_column :yhtion_toimipaikat, :nimitys, :string, limit: 100, default: '', null: false, after: :vat_numero
  end

  def down
    remove_column :yhtion_toimipaikat, :varastotoimipaikka
    remove_column :yhtion_toimipaikat, :nimitys
  end
end
