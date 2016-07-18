class AddCampaignColumn < ActiveRecord::Migration
  def change
    add_reference :asiakasalennus, :campaign, after: :piiri
    add_reference :asiakashinta,   :campaign, after: :piiri
    add_reference :hinnasto,       :campaign, after: :yhtion_toimipaikka_id
    add_reference :lasku,          :campaign, after: :piiri
    add_reference :tilausrivi,     :campaign, after: :suuntalava
  end
end
