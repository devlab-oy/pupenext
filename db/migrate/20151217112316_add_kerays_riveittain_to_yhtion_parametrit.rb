class AddKeraysRiveittainToYhtionParametrit < ActiveRecord::Migration
  def up
    add_column :yhtion_parametrit, :kerays_riveittain, :string, default: '', null: false, after: :keraysvahvistus_lahetys
  end

  def down
    remove_column :yhtion_parametrit, :kerays_riveittain
  end
end
