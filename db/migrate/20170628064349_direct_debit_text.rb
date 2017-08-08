class DirectDebitText < ActiveRecord::Migration
  def change
    add_column :directdebit, :teksti_fi, :text, after: :suoraveloitusmandaatti
    add_column :directdebit, :teksti_en, :text, after: :teksti_fi
    add_column :directdebit, :teksti_se, :text, after: :teksti_en
  end
end
