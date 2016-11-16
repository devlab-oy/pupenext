class AddApixEdiKeyToCompany < ActiveRecord::Migration
  def change
    add_column :yhtion_parametrit, :apix_edi_tunnus, :string, limit: 100, default: '', null: false, after: :apix_avain
    add_column :yhtion_parametrit, :apix_edi_avain,  :string, limit: 100, default: '', null: false, after: :apix_edi_tunnus
  end
end
