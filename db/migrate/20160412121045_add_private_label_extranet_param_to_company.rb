class AddPrivateLabelExtranetParamToCompany < ActiveRecord::Migration
  def change
    add_column :yhtion_parametrit, :extranet_private_label, :string, limit: 1, null: false, default: '', after: :extranet_keraysprioriteetti
  end
end
