class AddYhtionToimipaikkaToHinnasto < ActiveRecord::Migration
  def change
    add_reference :hinnasto, :yhtion_toimipaikka, index: true, foreign_key: true, after: :selite
  end
end
