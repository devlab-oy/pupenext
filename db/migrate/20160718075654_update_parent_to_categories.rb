class UpdateParentToCategories < ActiveRecord::Migration
  def up
    # rails on case sensitive STI columnin suhteen, joten päivitetään kaikki lowercase
    execute 'update dynaaminen_puu set laji = LOWER(laji)'

    Company.all.each do |company|
      Current.company = company

      # päivitetään kaikille tuotekategorioille parent_id
      company.product_categories.each { |c| update_parent_for_node(c) }

      # päivitetään kaikille asiakaskategorioille parent_id
      company.customer_categories.each { |c| update_parent_for_node(c) }
    end
  end

  private

    def update_parent_for_node(node)
      parent_id = node.class.select(:tunnus)
        .where('lft < ? AND rgt > ? AND tunnus != ?', node.lft, node.rgt, node.tunnus)
        .order('lft DESC').limit(1).try(:first).try(:tunnus)

      # käytetään update columns, että ohitetaan callbackit
      node.update_columns parent_id: parent_id
    end
end
