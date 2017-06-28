class Kalenterinaikavaliyhtionparam < ActiveRecord::Migration
  def change
  	add_column :yhtion_parametrit, :kalenteri_aikavali, :string, limit: 2, default: '', null: false, after: :kalenterimerkinnat
  end
end
