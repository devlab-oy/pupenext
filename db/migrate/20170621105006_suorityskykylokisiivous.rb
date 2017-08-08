class Suorityskykylokisiivous < ActiveRecord::Migration
  def change
    execute "truncate suorituskykyloki;"
  end
end
