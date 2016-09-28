class UpdateProductStatuses < ActiveRecord::Migration
  def change
    Company.all.each do |company|
      Current.company = company

      company.products.where.not(status: %w(A E P T X)).update_all(status: 'A')
      company.keywords.where(laji: :s).delete_all
    end
  end
end
