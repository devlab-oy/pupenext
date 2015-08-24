class DropYritiColumns < ActiveRecord::Migration
  def up
    remove_columns :yriti, :siirtoavain, :kasukupolvi, :sasukupolvi, :kertaavain, :siemen,
                           :salattukerta, :generointiavain, :asiakas, :pankki, :asiakastarkenne,
                           :pankkitarkenne, :nro, :kayttoavain
  end

  def down
    add_column :yriti, :siirtoavain,     :text
    add_column :yriti, :kasukupolvi,     :integer
    add_column :yriti, :sasukupolvi,     :integer
    add_column :yriti, :kertaavain,      :text
    add_column :yriti, :siemen,          :text
    add_column :yriti, :salattukerta,    :text
    add_column :yriti, :generointiavain, :text
    add_column :yriti, :asiakas,         :string
    add_column :yriti, :pankki,          :string
    add_column :yriti, :asiakastarkenne, :string
    add_column :yriti, :pankkitarkenne,  :string
    add_column :yriti, :nro,             :integer
    add_column :yriti, :kayttoavain,     :text
  end
end
