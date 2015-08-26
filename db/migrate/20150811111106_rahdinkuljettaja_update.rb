class RahdinkuljettajaUpdate < ActiveRecord::Migration
  def up
    remove_column :rahdinkuljettajat, :jalleenmyyjanro

    # We must loop all companies, because we need Current.company
    Company.find_each do |company|
      Current.company = company.yhtio

      Permission.where(nimi: 'yllapito.php', alanimi: 'rahdinkuljettajat').find_each do |permission|
        permission.update(nimi: 'pupenext/carriers', alanimi: '')
      end
    end
  end

  def down
    add_column :rahdinkuljettajat, :jalleenmyyjanro, :integer

    # We must loop all companies, because we need Current.company
    Company.find_each do |company|
      Current.company = company.yhtio

      Permission.where(nimi: 'pupenext/carriers', alanimi: '').find_each do |permission|
        permission.update(nimi: 'yllapito.php', alanimi: 'rahdinkuljettajat')
      end
    end
  end
end
