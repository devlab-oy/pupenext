class UpdateProductStatuses < ActiveRecord::Migration
  def change
    Company.all.each do |company|
      Current.company = company

      company.products.where.not(status: %w(A E P T)).update_all(status: 'A')
    end
  end
end
