class AsiakasvarastoCompanyParameter < ActiveRecord::Migration
  def up
    add_column :yhtion_parametrit, :asiakasvarasto, :string, limit: 5, default: '', null: false, after: :Ennakkolaskun_tyyppi
  end

    def down
      remove_column :yhtion_parametrit, :asiakasvarasto
    end
  end
