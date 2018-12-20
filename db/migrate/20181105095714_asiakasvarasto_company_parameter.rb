class AsiakasvarastoCompanyParameter < ActiveRecord::Migration
  def up
    add_column :yhtion_parametrit, :asiakasvarasto, :string, limit: 5, default: '', null: false, after: :Ennakkolaskun_tyyppi
    add_column :yhtio, :ennakkolaskun_asiakasvarasto, :string, limit: 6, default: '', null: false, after: :raaka_ainevarasto
  end

  def down
    remove_column :yhtion_parametrit, :asiakasvarasto
    remove_column :yhtio, :ennakkolaskun_asiakasvarasto
  end
end
