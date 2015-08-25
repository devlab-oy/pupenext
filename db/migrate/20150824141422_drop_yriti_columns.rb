class DropYritiColumns < ActiveRecord::Migration
  def up
    remove_columns :yriti, :siirtoavain, :kasukupolvi, :sasukupolvi, :kertaavain, :siemen,
                           :salattukerta, :generointiavain, :asiakas, :pankki, :asiakastarkenne,
                           :pankkitarkenne, :nro, :kayttoavain

    add_column :factoring,     :bank_account_id, :integer, { after: :yhtio }
    add_column :suoritus,      :bank_account_id, :integer, { after: :yhtio }
    add_column :tiliotedata,   :bank_account_id, :integer, { after: :yhtio }
    add_column :tiliotesaanto, :bank_account_id, :integer, { after: :yhtio }

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
    add_column :yriti, :siirtoavain,     :text,    { after: :yhtio }
    add_column :yriti, :kasukupolvi,     :integer, { after: :yhtio }
    add_column :yriti, :sasukupolvi,     :integer, { after: :yhtio }
    add_column :yriti, :kertaavain,      :text,    { after: :yhtio }
    add_column :yriti, :siemen,          :text,    { after: :yhtio }
    add_column :yriti, :salattukerta,    :text,    { after: :yhtio }
    add_column :yriti, :generointiavain, :text,    { after: :yhtio }
    add_column :yriti, :asiakas,         :string,  { after: :yhtio }
    add_column :yriti, :pankki,          :string,  { after: :yhtio }
    add_column :yriti, :asiakastarkenne, :string,  { after: :yhtio }
    add_column :yriti, :pankkitarkenne,  :string,  { after: :yhtio }
    add_column :yriti, :nro,             :integer, { after: :yhtio }
    add_column :yriti, :kayttoavain,     :text,    { after: :yhtio }

    remove_column :factoring,     :bank_account_id
    remove_column :suoritus,      :bank_account_id
    remove_column :tiliotedata,   :bank_account_id
    remove_column :tiliotesaanto, :bank_account_id

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
