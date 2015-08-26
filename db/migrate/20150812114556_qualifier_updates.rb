class QualifierUpdates < ActiveRecord::Migration
  def up
    # Isätarkenne can be null
    change_column :kustannuspaikka, :isa_tarkenne, :integer, default: nil, null: true

    # We must loop all companies, because we need Current.company
    Company.find_each do |company|
      Current.company = company.yhtio

      # Change permission to new route
      Permission.where(nimi: 'yllapito.php', alanimi: 'kustannuspaikka').find_each do |permission|
        permission.update(nimi: 'pupenext/qualifiers', alanimi: '')
      end

      # Update zero values to nil
      Qualifier.where(isa_tarkenne: 0).update_all(isa_tarkenne: nil)
    end
  end

  def down
    # Revert back to null false, set null values to zero
    change_column_null :kustannuspaikka, :isa_tarkenne, false, 0
    change_column :kustannuspaikka, :isa_tarkenne, :integer, default: 0, null: false

    Company.find_each do |company|
      Current.company = company.yhtio

      Permission.where(nimi: 'pupenext/qualifiers', alanimi: '').find_each do |permission|
        permission.update(nimi: 'yllapito.php', alanimi: 'kustannuspaikka')
      end
    end
  end
end
