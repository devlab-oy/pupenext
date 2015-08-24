class DropYritiColumns < ActiveRecord::Migration
  def up
    remove_columns :yriti, :siirtoavain, :kasukupolvi, :sasukupolvi, :kertaavain, :siemen,
                           :salattukerta, :generointiavain, :asiakas, :pankki, :asiakastarkenne,
                           :pankkitarkenne, :nro, :kayttoavain

    remove_index :yriti, name: :yhtio_tilino
    add_index    :yriti, [:yhtio, :tilino]
    add_index    :yriti, [:yhtio, :iban]

    Company.find_each do |company|
      Current.company = company.yhtio

      Permission.where(nimi: 'yllapito.php', alanimi: 'yriti').find_each do |permission|
        permission.update(nimi: 'pupenext/bank_accounts', alanimi: '')
      end
    end
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

    Company.find_each do |company|
      Current.company = company.yhtio

      Permission.where(nimi: 'pupenext/bank_accounts', alanimi: '').find_each do |permission|
        permission.update(nimi: 'yllapito.php', alanimi: 'yriti')
      end
    end

    remove_index :yriti, [:yhtio, :iban]
    remove_index :yriti, [:yhtio, :tilino]
    add_index    :yriti, [:yhtio, :tilino], unique: true, name: :yhtio_tilino
  end
end
