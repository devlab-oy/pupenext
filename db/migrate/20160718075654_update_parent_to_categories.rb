class UpdateParentToCategories < ActiveRecord::Migration
  def up
    Company.find_each do |company|
      Current.company = company

      # päivitetään kaikille tuotekategorioille parent_id
      company.product_categories.each do |c|
        parent_id = company.product_categories.select(:tunnus)
          .where("laji = ? AND lft < ? AND rgt > ? AND tunnus != ?", c.laji, c.lft, c.rgt, c.tunnus)
          .order("lft DESC").limit(1).try(:first).try(:tunnus)

        c.update(parent_id: parent_id)
      end

      # päivitetään kaikille asiakaskategorioille parent_id
      company.customer_categories.each do |c|
        parent_id = company.product_categories.select(:tunnus)
          .where("laji = ? AND lft < ? AND rgt > ? AND tunnus != ?", c.laji, c.lft, c.rgt, c.tunnus)
          .order("lft DESC").limit(1).try(:first).try(:tunnus)

        c.update(parent_id: parent_id)
      end

      # ajetaan vielä acts_as_nested_set korjausajot varmuudenvuoksi
      Category::Product.rebuild!
      Category::Customer.rebuild!
    end
  end
end
