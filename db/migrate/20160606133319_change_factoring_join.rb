class ChangeFactoringJoin < ActiveRecord::Migration
  def up
    add_reference :maksuehto, :factoring, after: :factoring

    # Loop companies
    Company.find_each do |company|
      Current.company = company.yhtio

      # Loop all terms that use factoring
      TermsOfPayment.where("factoring != ''").find_each do |top|
        # fetch name, find id by name, and update
        name = top.read_attribute :factoring
        fact = Factoring.find_by factoringyhtio: name
        top.update_attribute :factoring_id, fact.try(:tunnus)
      end
    end

    remove_column :maksuehto, :factoring
  end

  def down
    add_column :maksuehto, :factoring, :string, limit: 50, default: "", null: false, after: :factoring_id

    # Loop companies
    Company.find_each do |company|
      Current.company = company.yhtio

      # Loop all terms that use factoring
      TermsOfPayment.where("factoring_id is not null").find_each do |top|
        # update name as relation
        name = top.factoring.factoringyhtio
        top.update_column :factoring, top.factoring.factoringyhtio
      end
    end

    remove_reference :maksuehto, :factoring
  end
end
