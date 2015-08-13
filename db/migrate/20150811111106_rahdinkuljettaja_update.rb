class RahdinkuljettajaUpdate < ActiveRecord::Migration
  def up
    remove_column :rahdinkuljettajat, :jalleenmyyjanro

    # We must loop all companies, because we need Current.company
    Company.all.each do |company|
      Current.company = company.yhtio

      Permission.where(nimi: 'yllapito.php', alanimi: 'rahdinkuljettajat')
        .update_all(nimi: 'pupenext/carriers', alanimi: '')
    end
  end

  def down
    add_column :rahdinkuljettajat, :jalleenmyyjanro, :integer

    # We must loop all companies, because we need Current.company
    Company.all.each do |company|
      Current.company = company.yhtio

      Permission.where(nimi: 'pupenext/carriers', alanimi: '')
        .update_all(nimi: 'yllapito.php', alanimi: 'rahdinkuljettajat')
    end
  end
end
