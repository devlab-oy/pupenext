class AsiakasvarastoCompanyParameter < ActiveRecord::Migration
  def up
    add_column :yhtion_parametrit, :asiakasvarasto, :char, default: '', null: false, after: :Ennakkolaskun_tyyppi
  end

    def down
      remove_column :yhtion_parametrit, :asiakasvarasto
    end
  end
