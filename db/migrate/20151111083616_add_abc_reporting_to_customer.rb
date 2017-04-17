class AddAbcReportingToCustomer < ActiveRecord::Migration
  def up
    add_column :asiakas, :abc_raportointi, :string, limit: 1, default: '', null: false, after: :myynninseuranta
  end

  def down
    remove_column :asiakas, :abc_raportointi
  end
end
